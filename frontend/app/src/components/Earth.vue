<script setup>
import Globe from "globe.gl";
import { ref, computed, watch, onMounted, nextTick } from "vue";

// ────────────────────────────────────────────────────────────────
// State & Refs
// ────────────────────────────────────────────────────────────────
const globeDiv = ref(null);
const myGlobe = ref(null);
const geoData = ref(null);
const selectedVoyage = ref(null);
const voyageDetails = ref(null);
const isPlaying = ref(false);
const currentEventIndex = ref(0);
const showVoyageList = ref(true);
const selectedEvent = ref(null);
const allPaths = ref([]); // Store processed paths for filtering
let animationFrame = null;

// ─────────────────────────────────════════════════───────────────
// FIX 1: Random bright colors for each voyage (ENHANCED with caching)
// ─────────────────────────────────════════════════───────────────
const voyageColorCache = new Map(); // Cache colors per voyage ID

function ensureVisibleColor(voyageId) {
  // Return cached color if available
  if (voyageColorCache.has(voyageId)) {
    return voyageColorCache.get(voyageId);
  }

  // Generate random hue (0-360) for bright, distinct colors
  const hue = Math.floor(Math.random() * 360);
  const color = `hsl(${hue}, 85%, 60%)`; // High saturation, good visibility on dark globe

  // Cache the color
  voyageColorCache.set(voyageId, color);
  return color;
}

// ────────────────────────────────────────────────────────────────
// Voyage Selection (ENHANCED with better error handling)
// ────────────────────────────────────────────────────────────────
async function selectVoyage(voyageId) {
  try {
    const fullId = `voyage-${voyageId}`;
    selectedVoyage.value = fullId;
    isPlaying.value = false;
    currentEventIndex.value = 0;
    selectedEvent.value = null;
    showVoyageList.value = false;

    const res = await fetch(`/api/v1/voyages/${voyageId}/details`);
    if (!res.ok) throw new Error(`Failed to fetch voyage details: ${res.status}`);

    voyageDetails.value = await res.json();

    // FIX: Ensure globe and path exist before camera movement
    await nextTick();
    const startCoords = selectedPath.value?.geometry?.coordinates?.[0]?.[0];
    if (myGlobe.value && startCoords && Array.isArray(startCoords) && startCoords.length >= 2) {
      myGlobe.value.pointOfView({ lat: startCoords[1], lng: startCoords[0], altitude: 1.5 }, 1000);
    }
  } catch (error) {
    console.error("Error selecting voyage:", error);
    // Reset on error
    exitSelection();
  }
}

function exitSelection() {
  selectedVoyage.value = null;
  voyageDetails.value = null;
  isPlaying.value = false;
  currentEventIndex.value = 0;
  selectedEvent.value = null;
  showVoyageList.value = true;

  // FIX: Explicitly clear markers and reset view
  if (myGlobe.value) {
    myGlobe.value.pointOfView({ lat: 0, lng: 0, altitude: 2.5 }, 1000);
    // Clear all HTML elements (markers) immediately
    myGlobe.value.htmlElementsData([]);
  }
}

// ────────────────────────────────────────────────────────────────
// FIX 2: Handle antimeridian wrapping for proper shortest-path interpolation
// ────────────────────────────────────────────────────────────────
function correctLngWrap(lng1, lng2) {
  const delta = lng2 - lng1;
  if (delta > 180) return lng2 - 360;
  if (delta < -180) return lng2 + 360;
  return lng2;
}

// ────────────────────────────────────────────────────────────────
// Core Logic (ENHANCED with defensive checks)
// ────────────────────────────────────────────────────────────────
watch(currentEventIndex, (newVal) => {
  const numVal = Number(newVal);
  if (!isNaN(numVal) && numVal !== newVal) {
    currentEventIndex.value = numVal;
  }
});

const selectedPath = computed(() => {
  if (!selectedVoyage.value || !geoData.value?.features) return null;
  return geoData.value.features.find(f => f?.properties?.id === selectedVoyage.value);
});

const interpolatedPosition = computed(() => {
  if (!selectedPath.value?.geometry?.coordinates) return null;

  const coords = selectedPath.value.geometry.coordinates[0];
  if (!Array.isArray(coords) || coords.length === 0) return null;

  const index = Number(currentEventIndex.value) || 0;
  const maxIndex = coords.length - 1;
  const clampedIndex = Math.max(0, Math.min(index, maxIndex));

  const floor = Math.floor(clampedIndex);
  const ceil = Math.min(Math.ceil(clampedIndex), maxIndex);

  const coordFloor = coords[floor];
  const coordCeil = coords[ceil];

  if (!coordFloor || !coordCeil || !Array.isArray(coordFloor) || !Array.isArray(coordCeil)) return null;
  if (floor === ceil) return coordFloor;

  const [lng1, lat1] = coordFloor;
  const [lng2, lat2] = coordCeil;

  if (typeof lng1 !== 'number' || typeof lat1 !== 'number' || typeof lng2 !== 'number' || typeof lat2 !== 'number') return null;

  const fraction = clampedIndex - floor;

  const correctedLng2 = correctLngWrap(lng1, lng2);
  const interpolatedLng = lng1 + (correctedLng2 - lng1) * fraction;
  const interpolatedLat = lat1 + (lat2 - lat1) * fraction;

  return [interpolatedLng, interpolatedLat];
});

const currentDateDisplay = computed(() => {
  if (!voyageDetails.value?.events?.length) return "";

  const events = voyageDetails.value.events;
  const index = Number(currentEventIndex.value) || 0;
  const maxIndex = events.length - 1;
  const clampedIndex = Math.max(0, Math.min(index, maxIndex));

  const floor = Math.floor(clampedIndex);
  const ceil = Math.min(Math.ceil(clampedIndex), maxIndex);

  const eventFloor = events[floor];
  const eventCeil = events[ceil];

  if (!eventFloor || !eventCeil) return "";
  if (floor === ceil) return new Date(eventFloor.date).toLocaleDateString();

  const date1 = new Date(eventFloor.date).getTime();
  const date2 = new Date(eventCeil.date).getTime();

  if (isNaN(date1) || isNaN(date2)) return "";

  const fraction = clampedIndex - floor;
  const interpolated = date1 + (date2 - date1) * fraction;

  return new Date(interpolated).toLocaleDateString();
});

// ────────────────────────────────────────────────────────────────
// Animation & Controls (MODIFIED: 4x slower animation)
// ────────────────────────────────────────────────────────────────
function togglePlay() {
  isPlaying.value = !isPlaying.value;
}

function animate() {
  if (!isPlaying.value || !voyageDetails.value?.events?.length) return;

  const totalSteps = voyageDetails.value.events.length - 1;
  // CHANGED: 4x slower animation (0.01 / 4 = 0.0025)
  currentEventIndex.value = Number(currentEventIndex.value) + 0.0025;

  if (currentEventIndex.value >= totalSteps) {
    currentEventIndex.value = totalSteps;
    isPlaying.value = false;
  }
  animationFrame = requestAnimationFrame(animate);
}

watch(isPlaying, (playing) => {
  if (playing) animate();
  else if (animationFrame) cancelAnimationFrame(animationFrame);
});

// MODIFIED: 3x more zoomed in when playing (0.5 / 3 ≈ 0.1667)
watch([interpolatedPosition, isPlaying], ([pos, playing]) => {
  if (pos && playing && myGlobe.value) {
    myGlobe.value.pointOfView({ lat: pos[1], lng: pos[0], altitude: 0.1667 }, 100);
  }
});

// ────────────────────────────────────────────────────────────────
// Event Actions (ENHANCED)
// ────────────────────────────────────────────────────────────────
function showEventDetails(event) {
  if (event?.activity) {
    selectedEvent.value = event;
  }
}

function closeEventDetails() {
  selectedEvent.value = null;
}

// ────────────────────────────────────────────────────────────────
// Voyage List Sidebar (ENHANCED)
// ────────────────────────────────────────────────────────────────
const voyageList = computed(() => {
  if (!geoData.value?.features) return [];

  return geoData.value.features
    .filter(feature => feature?.properties?.id && feature?.properties?.name)
    .map(feature => ({
      id: feature.properties.id,
      name: feature.properties.name,
      shipName: feature.properties.shipName || 'Unknown Ship',
      color: feature.properties.color || '#5eead4'
    }));
});

// ────────────────────────────────────────────────────────────────
// FIX 3: Path filtering logic (ENHANCED with null checks)
// ────────────────────────────────────────────────────────────────
watch(selectedVoyage, (newVoyageId) => {
  if (!myGlobe.value || !allPaths.value?.length) {
    console.warn("Globe or paths not ready for update");
    return;
  }

  try {
    // Show only selected path when a voyage is active, otherwise show all
    const pathsToShow = newVoyageId
      ? allPaths.value.filter(p => p?.properties?.id === newVoyageId)
      : allPaths.value;

    myGlobe.value
      .pathsData(pathsToShow)
      .pathPoints("coords")
      .pathPointLat(p => Array.isArray(p) && p.length >= 2 ? p[1] : 0)
      .pathPointLng(p => Array.isArray(p) && p.length >= 2 ? p[0] : 0)
      .pathColor(path => path?.properties?.color || '#5eead4')
      .pathLabel(path => path?.properties?.name || 'Unnamed Voyage')
      .pathStroke(1.5)
      .pathDashLength(0.05)
      .pathDashGap(0.02)
      .pathDashAnimateTime(12000);
  } catch (error) {
    console.error("Error updating path display:", error);
  }
});

// ────────────────────────────────────────────────────────────────
// Weather Display Logic (ENHANCED)
// ────────────────────────────────────────────────────────────────
function getWeatherEmoji(weather) {
  if (!weather || typeof weather !== 'string') return '🌡️';

  const weatherLower = weather.toLowerCase();
  const emojiMap = {
    'clear': '☀️', 'sunny': '☀️',
    'cloud': '☁️', 'cloudy': '☁️', 'overcast': '☁️',
    'rain': '🌧️', 'rainy': '🌧️', 'shower': '🌦️',
    'storm': '⛈️', 'thunder': '⛈️',
    'snow': '❄️', 'snowy': '❄️',
    'fog': '🌫️', 'foggy': '🌫️', 'mist': '🌫️',
    'wind': '💨', 'windy': '💨', 'gale': '💨',
    'hurricane': '🌀', 'typhoon': '🌀',
    'calm': '🌊', 'smooth': '🌊', 'rough': '🌊', 'turbulent': '🌊',
  };

  for (const [key, emoji] of Object.entries(emojiMap)) {
    if (weatherLower.includes(key)) return emoji;
  }

  return '🌡️'; // default emoji
}

const currentWeatherEvent = computed(() => {
  if (!voyageDetails.value?.events?.length) return null;

  const events = voyageDetails.value.events;
  const index = Number(currentEventIndex.value) || 0;
  const nearestIndex = Math.round(index);
  const clampedIndex = Math.max(0, Math.min(nearestIndex, events.length - 1));

  return events[clampedIndex];
});

// ────────────────────────────────────────────────────────────────
// FIX 4: Initialize globe with random colors and store paths (ENHANCED)
// ────────────────────────────────────────────────────────────────
onMounted(async () => {
  try {
    if (!globeDiv.value) {
      throw new Error("Globe container not found");
    }

    myGlobe.value = Globe()(globeDiv.value)
      .globeImageUrl("//unpkg.com/three-globe/example/img/earth-night.jpg")
      .bumpImageUrl("//unpkg.com/three-globe/example/img/earth-topology.png")
      .backgroundImageUrl("//unpkg.com/three-globe/example/img/night-sky.png")
      .showAtmosphere(true)
      .atmosphereColor('#3a228a')
      .atmosphereAltitude(0.2);

    const res = await fetch("/api/v1/voyages-geo");
    if (!res.ok) throw new Error(`Failed to fetch geo data: ${res.status}`);

    const data = await res.json();

    // FIX: Validate data structure before assignment
    if (!data || !Array.isArray(data.features)) {
      throw new Error("Invalid geo data structure");
    }

    geoData.value = data;

    // Process and store all paths with random colors
    allPaths.value = geoData.value.features
      .filter(feature => {
        // FIX: Validate feature structure
        const isValid = feature?.geometry?.coordinates?.[0]?.length >= 2 &&
          feature?.properties?.id &&
          Array.isArray(feature.geometry.coordinates[0]);

        if (!isValid) {
          console.warn("Invalid feature skipped:", feature?.properties?.id);
        }

        return isValid;
      })
      .map(feature => {
        const coords = feature.geometry.coordinates[0].filter(
          coord => Array.isArray(coord) &&
            coord.length >= 2 &&
            typeof coord[0] === 'number' &&
            typeof coord[1] === 'number' &&
            !isNaN(coord[0]) &&
            !isNaN(coord[1])
        );

        // Assign random bright color
        feature.properties.color = ensureVisibleColor(feature.properties.id);

        return {
          coords,
          properties: feature.properties,
        };
      })
      .filter(Boolean); // Remove null entries

    // Wait for DOM update before rendering paths
    await nextTick();

    // FIX: Double-check globe is still available
    if (myGlobe.value) {
      myGlobe.value
        .pathsData(allPaths.value)
        .pathPoints("coords")
        .pathPointLat(p => Array.isArray(p) && p.length >= 2 ? p[1] : 0)
        .pathPointLng(p => Array.isArray(p) && p.length >= 2 ? p[0] : 0)
        .pathColor(path => path?.properties?.color || '#5eead4')
        .pathLabel(path => path?.properties?.name || 'Unnamed Voyage')
        .pathStroke(1.5)
        .pathDashLength(0.05)
        .pathDashGap(0.02)
        .pathDashAnimateTime(12000)
        .onPathClick(path => {
          if (path?.properties?.id) {
            selectVoyage(path.properties.id.replace('voyage-', ''));
          }
        });
    }
  } catch (error) {
    console.error("Error initializing globe:", error);
  }
});

// ────────────────────────────────────────────────────────────────
// Markers & Boat Updates (FIXED: Now clears markers on exit)
// ────────────────────────────────────────────────────────────────
watch([voyageDetails, myGlobe, interpolatedPosition], ([details, globe, pos]) => {
  if (!globe) return; // Globe must exist

  // FIX: Explicitly clear markers when no details (on exit)
  if (!details || !details.events?.length) {
    globe.htmlElementsData([]);
    return;
  }

  const markers = details.events
    .filter(event => event && typeof event.latitude === 'number' && typeof event.longitude === 'number')
    .map(event => ({
      lat: event.latitude,
      lng: event.longitude,
      activity: event.activity || 'Unknown Activity',
      weather: event.weather,
      date: event.date,
      type: 'event',
      hasDetails: !!(event.description || event.specialOccurrence),
      description: event.description || '',
      special: event.specialOccurrence || ''
    }));

  if (pos && Array.isArray(pos) && pos.length >= 2) {
    markers.push({
      lat: pos[1],
      lng: pos[0],
      type: 'boat'
    });
  }

  globe.htmlElementsData(markers)
    .htmlElement(d => {
      if (d.type === 'boat') {
        const el = document.createElement('div');
        el.className = 'boat-marker';
        el.innerHTML = '⛵';
        el.style.fontSize = '24px';
        el.style.pointerEvents = 'none';
        el.style.zIndex = '101';
        return el;
      } else {
        const el = document.createElement('div');
        el.className = 'event-marker';
        el.innerHTML = d.hasDetails ? '⭐' : '📍';
        el.title = `${d.activity}\n${new Date(d.date).toLocaleDateString()}\nWeather: ${d.weather || 'N/A'}`;
        el.style.fontSize = d.hasDetails ? '24px' : '20px';
        el.style.cursor = d.hasDetails ? 'pointer' : 'default';
        if (d.hasDetails) el.onclick = () => showEventDetails(d);
        return el;
      }
    })
    .htmlLat(d => typeof d.lat === 'number' ? d.lat : 0)
    .htmlLng(d => typeof d.lng === 'number' ? d.lng : 0);
});

// ────────────────────────────────────────────────────────────────
// ADDITIONAL FIX: Watch for globe readiness to ensure paths render
// ────────────────────────────────────────────────────────────────
watch([myGlobe, allPaths], ([globe, paths]) => {
  if (globe && paths?.length && !selectedVoyage.value) {
    // Re-render all paths when globe becomes ready
    try {
      globe.pathsData(paths)
        .pathPoints("coords")
        .pathPointLat(p => Array.isArray(p) && p.length >= 2 ? p[1] : 0)
        .pathPointLng(p => Array.isArray(p) && p.length >= 2 ? p[0] : 0)
        .pathColor(path => path?.properties?.color || '#5eead4')
        .pathLabel(path => path?.properties?.name || 'Unnamed Voyage')
        .pathStroke(1.5)
        .pathDashLength(0.05)
        .pathDashGap(0.02)
        .pathDashAnimateTime(12000);
    } catch (error) {
      console.error("Error in globe readiness watcher:", error);
    }
  }
});
</script>

<template>
  <div ref="globeDiv" class="globe-container"></div>

  <!-- Weather Display -->
  <div v-if="selectedVoyage && currentWeatherEvent" class="weather-display">
    <div class="weather-emoji">{{ getWeatherEmoji(currentWeatherEvent.weather) }}</div>
    <div class="weather-details">
      <div class="weather-main">
        <span class="weather-condition">{{ currentWeatherEvent.weather || 'Weather data not available' }}</span>
        <span class="weather-activity">{{ currentWeatherEvent.activity || 'No activity recorded' }}</span>
      </div>
      <div class="weather-date">{{ new Date(currentWeatherEvent.date).toLocaleDateString() }}</div>
    </div>
  </div>

  <!-- Voyage List Sidebar -->
  <div class="voyage-list-panel" :class="{ 'mobile-hidden': !showVoyageList && selectedVoyage }">
    <div class="panel-header">
      <h2>Voyages</h2>
      <button
        v-if="selectedVoyage"
        @click="showVoyageList = !showVoyageList"
        class="toggle-btn"
      >
        {{ showVoyageList ? '−' : '+' }}
      </button>
    </div>
    <div class="voyage-list">
      <div
        v-for="voyage in voyageList"
        :key="voyage.id"
        @click="selectVoyage(voyage.id.replace('voyage-', ''))"
        class="voyage-item"
        :class="{ active: selectedVoyage === voyage.id }"
      >
        <div class="voyage-color" :style="{ backgroundColor: voyage.color }"></div>
        <div class="voyage-info">
          <div class="voyage-name">{{ voyage.name }}</div>
          <div class="voyage-ship">{{ voyage.shipName }}</div>
        </div>
      </div>
    </div>
  </div>

  <!-- Exit Button -->
  <button v-if="selectedVoyage" @click="exitSelection" class="exit-btn">
    ✕ Exit Voyage
  </button>

  <!-- Voyage Info Panel -->
  <div v-if="selectedVoyage && voyageDetails" class="info-panel">
    <h3>{{ voyageDetails.ship?.shipName || 'Unknown Ship' }}</h3>
    <p class="route">
      {{ voyageDetails.voyage?.startingPort || 'Unknown' }} →
      {{ voyageDetails.voyage?.destinationPort || 'Unknown' }}
    </p>
    <p class="detail">Captain: {{ voyageDetails.voyage?.captainName || 'Unknown' }}</p>
    <p class="detail">Crew Count: {{ voyageDetails.voyage?.crewCount ?? 'N/A' }}</p>
    <p class="detail">Casualties: {{ voyageDetails.voyage?.casualties ?? 'N/A' }}</p>
    <p class="detail">Start Date: {{ voyageDetails.voyage?.startDate ? new Date(voyageDetails.voyage.startDate).toLocaleDateString() : 'Unknown' }}</p>
  </div>

  <!-- Timeline Controls -->
  <div v-if="selectedVoyage && voyageDetails?.events?.length" class="timeline-controls">
    <button @click="togglePlay" class="play-btn">
      {{ isPlaying ? '⏸️' : '▶️' }}
    </button>
    <input
      type="range"
      min="0"
      :max="(voyageDetails.events.length - 1) || 0"
      v-model.number="currentEventIndex"
      step="0.01"
      class="timeline-slider"
    />
    <span class="date-display">{{ currentDateDisplay }}</span>
  </div>

  <!-- Event Detail Popup -->
  <div v-if="selectedEvent" class="event-popup" @click="closeEventDetails">
    <div class="event-popup-content" @click.stop>
      <button class="close-popup" @click="closeEventDetails">✕</button>
      <h4>{{ selectedEvent.activity }}</h4>
      <p><strong>Date:</strong> {{ new Date(selectedEvent.date).toLocaleDateString() }}</p>
      <p><strong>Weather:</strong> {{ selectedEvent.weather || 'N/A' }}</p>
      <p v-if="selectedEvent.description"><strong>Details:</strong> {{ selectedEvent.description }}</p>
      <p v-if="selectedEvent.special"><strong>⚠️ Special Note:</strong> {{ selectedEvent.special }}</p>
    </div>
  </div>
</template>

<style>
/* All styles remain the same as in original code */
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
  overflow: hidden;
}

.globe-container {
  width: 100vw;
  height: 100vh;
}

/* Voyage List Panel */
.voyage-list-panel {
  position: absolute;
  top: 20px;
  left: 20px;
  width: 320px;
  max-height: 80vh;
  background: rgba(15, 23, 42, 0.9);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(94, 234, 212, 0.2);
  border-radius: 12px;
  z-index: 1000;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
  display: flex;
  flex-direction: column;
  transition: transform 0.3s ease;
}

.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid rgba(94, 234, 212, 0.2);
}

.panel-header h2 {
  color: #5eead4;
  font-size: 1.25rem;
  margin: 0;
}

.toggle-btn {
  background: rgba(94, 234, 212, 0.2);
  border: 1px solid #5eead4;
  border-radius: 6px;
  color: #5eead4;
  width: 30px;
  height: 30px;
  cursor: pointer;
  font-size: 18px;
  display: none;
}

.voyage-list {
  overflow-y: auto;
  max-height: calc(80vh - 70px);
  padding: 8px;
}

.voyage-item {
  display: flex;
  align-items: center;
  padding: 12px;
  margin-bottom: 8px;
  background: rgba(30, 41, 59, 0.6);
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.voyage-item:hover {
  background: rgba(51, 65, 85, 0.8);
  transform: translateX(4px);
}

.voyage-item.active {
  background: rgba(94, 234, 212, 0.2);
  border: 1px solid #5eead4;
}

.voyage-color {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  margin-right: 12px;
  flex-shrink: 0;
}

.voyage-info {
  flex: 1;
  min-width: 0;
}

.voyage-name {
  color: #f8fafc;
  font-weight: 500;
  font-size: 0.95rem;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.voyage-ship {
  color: #cbd5e1;
  font-size: 0.8rem;
  margin-top: 2px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* Exit Button */
.exit-btn {
  position: absolute;
  top: 20px;
  right: 20px;
  padding: 12px 24px;
  background: rgba(220, 38, 38, 0.95); /* Red for visibility */
  color: #ffffff;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  z-index: 2000; /* Highest z-index */
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.4);
}

.exit-btn:hover {
  background: rgba(239, 68, 68, 1);
  transform: scale(1.05);
}

/* Info Panel */
.info-panel {
  position: absolute;
  top: 20px;
  right: 20px;
  padding: 24px;
  background: rgba(15, 23, 42, 0.9);
  color: #e2e8f0;
  border-radius: 12px;
  max-width: 320px;
  z-index: 1000;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(94, 234, 212, 0.2);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
}

.info-panel h3 {
  margin: 0 0 16px 0;
  color: #5eead4;
  font-size: 1.5rem;
  border-bottom: 2px solid #5eead4;
  padding-bottom: 8px;
}

.info-panel .route {
  font-size: 1.1rem;
  font-weight: 500;
  color: #f8fafc;
  margin-bottom: 16px;
}

.info-panel .detail {
  margin: 8px 0;
  font-size: 0.95rem;
  color: #cbd5e1;
  line-height: 1.4;
}

/* Timeline Controls */
.timeline-controls {
  position: absolute;
  bottom: 30px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  align-items: center;
  gap: 20px;
  padding: 20px 30px;
  background: rgba(15, 23, 42, 0.9);
  color: #e2e8f0;
  border-radius: 12px;
  z-index: 1000;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(94, 234, 212, 0.2);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
  flex-wrap: wrap;
}

.play-btn {
  background: rgba(94, 234, 212, 0.2);
  border: 2px solid #5eead4;
  border-radius: 50%;
  width: 50px;
  height: 50px;
  font-size: 20px;
  cursor: pointer;
  color: #5eead4;
  transition: all 0.3s ease;
  flex-shrink: 0;
}

.play-btn:hover {
  background: rgba(94, 234, 212, 0.3);
  transform: scale(1.1);
}

.timeline-slider {
  width: 400px;
  height: 6px;
  background: rgba(148, 163, 184, 0.3);
  border-radius: 3px;
  outline: none;
  -webkit-appearance: none;
  min-width: 200px;
  flex: 1;
}

.timeline-slider::-webkit-slider-thumb {
  -webkit-appearance: none;
  width: 18px;
  height: 18px;
  background: #5eead4;
  border-radius: 50%;
  cursor: pointer;
  box-shadow: 0 0 10px rgba(94, 234, 212, 0.5);
}

.timeline-slider::-moz-range-thumb {
  width: 18px;
  height: 18px;
  background: #5eead4;
  border-radius: 50%;
  cursor: pointer;
  border: none;
  box-shadow: 0 0 10px rgba(94, 234, 212, 0.5);
}

.date-display {
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.9rem;
  color: #5eead4;
  min-width: 120px;
  text-align: right;
  flex-shrink: 0;
}

/* Markers */
:global(.event-marker) {
  font-size: 20px;
  cursor: pointer;
  transition: transform 0.2s ease;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.8));
}

:global(.event-marker:hover) {
  transform: scale(1.3);
}

:global(.boat-marker) {
  font-size: 24px;
  filter: drop-shadow(0 2px 6px rgba(0, 0, 0, 0.9));
  pointer-events: none;
  z-index: 101;
}

/* Event Detail Popup */
.event-popup {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.7);
  z-index: 2000;
  display: flex;
  align-items: center;
  justify-content: center;
}

.event-popup-content {
  background: rgba(15, 23, 42, 0.95);
  border: 1px solid #5eead4;
  border-radius: 12px;
  padding: 24px;
  max-width: 400px;
  color: #e2e8f0;
  position: relative;
}

.close-popup {
  position: absolute;
  top: 10px;
  right: 10px;
  background: none;
  border: none;
  color: #5eead4;
  font-size: 20px;
  cursor: pointer;
}

.event-popup-content h4 {
  color: #5eead4;
  margin-bottom: 16px;
  font-size: 1.2rem;
}

.event-popup-content p {
  margin: 8px 0;
  line-height: 1.5;
}

.event-popup-content strong {
  color: #5eead4;
}

/* Responsive Design */
@media (max-width: 768px) {
  .voyage-list-panel {
    width: 100%;
    max-width: 300px;
    top: auto;
    bottom: 0;
    left: 0;
    right: 0;
    max-height: 40vh;
    transform: translateY(calc(100% - 60px));
    border-radius: 12px 12px 0 0;
  }

  .voyage-list-panel:not(.mobile-hidden) {
    transform: translateY(0);
  }

  .toggle-btn {
    display: block;
  }

  .info-panel {
    top: auto;
    bottom: 100px;
    left: 10px;
    right: 10px;
    max-width: none;
  }

  .timeline-controls {
    bottom: 10px;
    left: 10px;
    right: 10px;
    transform: none;
    padding: 15px 20px;
    gap: 10px;
  }

  .timeline-slider {
    width: 100%;
    min-width: auto;
  }

  .exit-btn {
    top: 10px;
    right: 10px;
    padding: 10px 16px;
    font-size: 0.9rem;
  }
}

@media (max-width: 480px) {
  .timeline-controls {
    flex-direction: column;
    align-items: stretch;
    gap: 15px;
  }

  .play-btn {
    width: 40px;
    height: 40px;
    font-size: 16px;
  }

  .date-display {
    text-align: center;
  }

  .info-panel {
    padding: 15px;
  }

  .info-panel h3 {
    font-size: 1.2rem;
  }

  .event-popup-content {
    margin: 20px;
    max-width: none;
  }
}

/* Scrollbar Styling */
.voyage-list::-webkit-scrollbar {
  width: 8px;
}

.voyage-list::-webkit-scrollbar-track {
  background: rgba(15, 23, 42, 0.5);
  border-radius: 4px;
}

.voyage-list::-webkit-scrollbar-thumb {
  background: #5eead4;
  border-radius: 4px;
}

/* Weather Display */
.weather-display {
  position: absolute;
  top: 20px;
  left: 50%;
  transform: translateX(-50%);
  background: rgba(15, 23, 42, 0.9);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(94, 234, 212, 0.2);
  border-radius: 12px;
  padding: 16px 24px;
  color: #e2e8f0;
  z-index: 1500;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
  min-width: 300px;
  max-width: 500px;
}

.weather-emoji {
  font-size: 48px;
  line-height: 1;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.8));
}

.weather-details {
  flex: 1;
}

.weather-main {
  display: flex;
  flex-direction: column;
  gap: 4px;
  margin-bottom: 8px;
}

.weather-condition {
  font-size: 1.2rem;
  font-weight: 600;
  color: #5eead4;
}

.weather-activity {
  font-size: 1rem;
  color: #cbd5e1;
}

.weather-date {
  font-size: 0.85rem;
  color: #94a3b8;
  font-family: 'JetBrains Mono', monospace;
}

/* Responsive adjustments for weather display */
@media (max-width: 768px) {
  .weather-display {
    top: 60px; /* Below exit button */
    left: 10px;
    right: 10px;
    transform: none;
    padding: 12px 16px;
    min-width: auto;
    max-width: none;
  }

  .weather-emoji {
    font-size: 36px;
  }

  .weather-condition {
    font-size: 1rem;
  }

  .weather-activity {
    font-size: 0.9rem;
  }
}

@media (max-width: 480px) {
  .weather-display {
    flex-direction: column;
    text-align: center;
    gap: 12px;
  }
}
</style>
