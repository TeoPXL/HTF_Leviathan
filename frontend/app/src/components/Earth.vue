<script setup>
import Globe from "globe.gl";
import { ref, onMounted } from "vue";

const globeDiv = ref(null);

// Deterministic color generator from a string (voyageId or name)
function hashColor(str) {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    hash = str.charCodeAt(i) + ((hash << 5) - hash);
  }
  // Generate vibrant HSL color
  const h = Math.abs(hash) % 360; // Hue between 0-359
  const s = 70 + (Math.abs(hash) % 20); // Saturation 70-90%
  const l = 45 + (Math.abs(hash) % 10); // Lightness 45-55%
  return `hsl(${h},${s}%,${l}%)`;
}

onMounted(async () => {
  const myGlobe = Globe()(globeDiv.value)
    .globeImageUrl("//unpkg.com/three-globe/example/img/earth-night.jpg")
    .bumpImageUrl("//unpkg.com/three-globe/example/img/earth-topology.png")
    .backgroundImageUrl("//unpkg.com/three-globe/example/img/night-sky.png");

  // Fetch voyages GeoJSON
  const res = await fetch("/api/v1/voyages-geo");
  const geoData = await res.json();

  // Convert voyages into pathsData
  const paths = [];
  geoData.features.forEach((feature) => {
    feature.geometry.coordinates.forEach((coordsLine) => {
      paths.push({
        coords: coordsLine,
        properties: {
          ...feature.properties,
          color: hashColor(feature.properties.id), // deterministic color per voyage
        },
      });
    });
  });

  // Set the paths on the globe
  myGlobe
    .pathsData(paths)
    .pathPoints("coords")
    .pathPointLat((p) => p[1])
    .pathPointLng((p) => p[0])
    .pathColor((path) => path.properties.color)
    .pathLabel((path) => path.properties.name)
    .pathStroke((path) => 2.5) // thicker lines
    .pathDashLength(0.05)
    .pathDashGap(0.02)
    .pathDashAnimateTime(12000);
});
</script>

<template>
  <div ref="globeDiv" style="width: 100vw; height: 100vh;"></div>
</template>
