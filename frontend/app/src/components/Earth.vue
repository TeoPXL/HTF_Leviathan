<script setup>
import Globe from "globe.gl";
import { ref, computed, watch, onMounted } from "vue";

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
let animationFrame = null;

// ────────────────────────────────────────────────────────────────
// FIX 1: Ensure currentEventIndex is always a number
// ────────────────────────────────────────────────────────────────
watch(currentEventIndex, (newVal) => {
  if (typeof newVal === "string") {
    currentEventIndex.value = Number(newVal);
  }
});

// ────────────────────────────────────────────────────────────────
// Computed Properties
// ────────────────────────────────────────────────────────────────
const selectedPath = computed(() => {
  if (!selectedVoyage.value || !geoData.value) return null;
  return geoData.value.features.find(f => f.properties.id === selectedVoyage.value);
});

const interpolatedPosition = computed(() => {
  if (!selectedPath.value) return null;

  const coords = selectedPath.value.geometry.coordinates[0];
  if (!coords.length) return null;

  // Force number and clamp
  const index = Number(currentEventIndex.value);
  const maxIndex = coords.length - 1;
  const clampedIndex = Math.max(0, Math.min(index, maxIndex));

  const floor = Math.floor(clampedIndex);
  const ceil = Math.min(Math.ceil(clampedIndex), maxIndex);

  if (!coords[floor] || !coords[ceil]) return null;
  if (floor === ceil) return coords[floor];

  const [lng1, lat1] = coords[floor];
  const [lng2, lat2] = coords[ceil];
  const fraction = clampedIndex - floor;

  return [
    lng1 + (lng2 - lng1) * fraction,
    lat1 + (lat2 - lat1) * fraction,
  ];
});

const currentDateDisplay = computed(() => {
  if (!voyageDetails.value?.events?.length) return "";

  const events = voyageDetails.value.events;
  const index = Number(currentEventIndex.value);
  const maxIndex = events.length - 1;
  const clampedIndex = Math.max(0, Math.min(index, maxIndex));

  const floor = Math.floor(clampedIndex);
  const ceil = Math.min(Math.ceil(clampedIndex), maxIndex);

  if (!events[floor] || !events[ceil]) return "";

  if (floor === ceil) {
    return new Date(events[floor].date).toLocaleDateString();
  }

  const date1 = new Date(events[floor].date).getTime();
  const date2 = new Date(events[ceil].date).getTime();
  const fraction = clampedIndex - floor;
  const interpolated = date1 + (date2 - date1) * fraction;

  return new Date(interpolated).toLocaleDateString();
});

// ────────────────────────────────────────────────────────────────
// Color Generator
// ────────────────────────────────────────────────────────────────
function hashColor(str) {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    hash = str.charCodeAt(i) + ((hash << 5) - hash);
  }
  const h = Math.abs(hash) % 360;
  const s = 70 + (Math.abs(hash) % 20);
  const l = 45 + (Math.abs(hash) % 10);
  return `hsl(${h},${s}%,${l}%)`;
}

// ────────────────────────────────────────────────────────────────
// FIX 3: Ensure animation uses number arithmetic
// ────────────────────────────────────────────────────────────────
function animate() {
  if (!isPlaying.value || !voyageDetails.value) return;

  const totalSteps = voyageDetails.value.events.length - 1;
  currentEventIndex.value = Number(currentEventIndex.value) + 0.01;

  if (currentEventIndex.value >= totalSteps) {
    currentEventIndex.value = totalSteps;
    isPlaying.value = false;
  }

  animationFrame = requestAnimationFrame(animate);
}

watch(isPlaying, (playing) => {
  if (playing) {
    animate();
  } else {
    cancelAnimationFrame(animationFrame);
  }
});

// ────────────────────────────────────────────────────────────────
// Camera Lock Logic
// ────────────────────────────────────────────────────────────────
watch([interpolatedPosition, isPlaying], ([pos, playing]) => {
  if (pos && playing && myGlobe.value) {
    myGlobe.value.pointOfView({
      lat: pos[1],
      lng: pos[0],
      altitude: 0.5
    }, 100);
  }
});

// ────────────────────────────────────────────────────────────────
// Voyage Selection
// ────────────────────────────────────────────────────────────────
async function selectVoyage(voyageId) {
  selectedVoyage.value = voyageId;
  isPlaying.value = false;
  currentEventIndex.value = 0;

  const res = await fetch(`/api/v1/voyages/${voyageId}/details`);
  voyageDetails.value = await res.json();

  const startCoords = selectedPath.value.geometry.coordinates[0][0];
  if (myGlobe.value && startCoords) {
    myGlobe.value.pointOfView({
      lat: startCoords[1],
      lng: startCoords[0],
      altitude: 1.5
    }, 1000);
  }
}

function exitSelection() {
  selectedVoyage.value = null;
  voyageDetails.value = null;
  isPlaying.value = false;
  currentEventIndex.value = 0;

  if (myGlobe.value) {
    myGlobe.value.pointOfView({ lat: 0, lng: 0, altitude: 2.5 }, 1000);
  }
}

function togglePlay() {
  isPlaying.value = !isPlaying.value;
}

// ────────────────────────────────────────────────────────────────
// Globe Initialization
// ────────────────────────────────────────────────────────────────
onMounted(async () => {
  myGlobe.value = Globe()(globeDiv.value)
    .globeImageUrl("//unpkg.com/three-globe/example/img/earth-night.jpg")
    .bumpImageUrl("//unpkg.com/three-globe/example/img/earth-topology.png")
    .backgroundImageUrl("//unpkg.com/three-globe/example/img/night-sky.png")
    .showAtmosphere(true)
    .atmosphereColor('#3a228a')
    .atmosphereAltitude(0.2);

  const res = await fetch("/api/v1/voyages-geo");
  geoData.value = await res.json();

  const paths = geoData.value.features.map(feature => ({
    coords: feature.geometry.coordinates[0],
    properties: feature.properties,
  }));

  myGlobe.value
    .pathsData(paths)
    .pathPoints("coords")
    .pathPointLat(p => p[1])
    .pathPointLng(p => p[0])
    .pathColor(path => path.properties.color)
    .pathLabel(path => path.properties.name)
    .pathStroke(2)
    .pathDashLength(0.05)
    .pathDashGap(0.02)
    .pathDashAnimateTime(12000)
    .onPathClick(path => selectVoyage(path.properties.id.replace('voyage-', '')));

  const startPorts = paths.map(path => ({
    lat: path.coords[0][1],
    lng: path.coords[0][0],
    size: 3,
    color: path.properties.color,
  }));

  myGlobe.value
    .pointsData(startPorts)
    .pointLat(d => d.lat)
    .pointLng(d => d.lng)
    .pointAltitude(0.01)
    .pointColor(d => d.color)
    .pointRadius(d => d.size);
});

watch([voyageDetails, myGlobe], ([details, globe]) => {
  if (!details || !globe) return;

  const markers = details.events.map(event => ({
    lat: event.latitude,
    lng: event.longitude,
    activity: event.activity,
    weather: event.weather,
    date: event.date,
  }));

  globe.htmlElementsData(markers)
    .htmlElement(d => {
      const el = document.createElement('div');
      el.className = 'event-marker';
      el.innerHTML = '📍';
      el.title = `${d.activity}\n${new Date(d.date).toLocaleDateString()}\nWeather: ${d.weather || 'N/A'}`;
      el.style.fontSize = '20px';
      el.style.cursor = 'pointer';
      return el;
    })
    .lat(d => d.lat)
    .lng(d => d.lng);
});
</script>

<template>
  <div ref="globeDiv" style="width: 100vw; height: 100vh;"></div>

  <!-- Exit Button -->
  <button v-if="selectedVoyage" @click="exitSelection" class="exit-btn">
    ✕ Exit Voyage
  </button>

  <!-- Voyage Info Panel -->
  <div v-if="selectedVoyage && voyageDetails" class="info-panel">
    <h3>{{ voyageDetails.ship.shipName }}</h3>
    <p class="route">{{ voyageDetails.voyage.startingPort }} → {{ voyageDetails.voyage.destinationPort }}</p>
    <p class="detail">Captain: {{ voyageDetails.voyage.captainName }}</p>
    <p class="detail">Crew Count: {{ voyageDetails.voyage.crewCount }}</p>
    <p class="detail">Casualties: {{ voyageDetails.voyage.casualties }}</p>
    <p class="detail">Start Date: {{ new Date(voyageDetails.voyage.startDate).toLocaleDateString() }}</p>
  </div>

  <!-- Timeline Controls -->
  <div v-if="selectedVoyage && voyageDetails" class="timeline-controls">
    <button @click="togglePlay" class="play-btn">
      {{ isPlaying ? '⏸️' : '▶️' }}
    </button>
    <input
      type="range"
      min="0"
      :max="voyageDetails.events.length - 1"
      v-model.number="currentEventIndex"
      step="0.01"
      class="timeline-slider"
    />
    <span class="date-display">{{ currentDateDisplay }}</span>
  </div>

  <!-- Boat Marker (uses Globe.gl's HTML elements layer) -->
  <div v-if="interpolatedPosition" class="boat-marker"
       :style="{
         position: 'absolute',
         transform: 'translate(-50%, -50%)',
         left: '50%',
         top: '50%',
         zIndex: 100,
         pointerEvents: 'none'
       }">
    ⛵
  </div>
</template>


<style>
/* Reset box model */
* {
  box-sizing: border-box;
}

/* Exit Button */
.exit-btn {
  position: absolute;
  top: 20px;
  right: 20px;
  padding: 12px 24px;
  background: rgba(15, 23, 42, 0.9);
  color: #e2e8f0;
  border: 1px solid rgba(94, 234, 212, 0.3);
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  z-index: 1000;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
}

.exit-btn:hover {
  background: rgba(220, 38, 38, 0.9);
  transform: scale(1.05);
}

/* Info Panel */
.info-panel {
  position: absolute;
  top: 20px;
  left: 20px;
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
}

/* Event Markers (when selected) */
:global(.event-marker) {
  font-size: 24px;
  cursor: pointer;
  transition: transform 0.2s ease;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.8));
}

:global(.event-marker:hover) {
  transform: scale(1.3);
}
</style>
