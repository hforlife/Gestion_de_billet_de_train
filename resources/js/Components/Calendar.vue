<template>
  <div class="bg-white rounded-xl shadow-md p-4 h-full">
    <FullCalendar ref="calendar" :options="calendarOptions" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { usePage } from '@inertiajs/vue3';
import FullCalendar from '@fullcalendar/vue3';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import interactionPlugin from '@fullcalendar/interaction';
import frLocale from '@fullcalendar/core/locales/fr';

const props = defineProps({
  initialVoyages: {
    type: Array,
    default: () => []
  }
});

const calendar = ref(null);
const calendarOptions = ref({
  plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin],
  initialView: 'dayGridMonth',
  locales: [frLocale],
  locale: 'fr',
  headerToolbar: {
    left: 'prev,next today',
    center: 'title',
    right: 'dayGridMonth,timeGridWeek,timeGridDay'
  },
  events: props.initialVoyages,
  eventClick: (info) => {
    info.jsEvent.preventDefault();
    if (info.event.url) {
      window.open(info.event.url, '_blank');
    }
  },
  eventContent: (arg) => {
    return {
      html: `
        <div class="fc-event-main-frame">
          <div class="fc-event-title-container">
            <div class="fc-event-title fc-sticky">${arg.event.title}</div>
          </div>
          <div class="fc-event-time">${arg.timeText}</div>
        </div>
      `
    };
  },
  eventClassNames: (arg) => {
    return ['shadow-sm', 'border-0'];
  },
  height: 'auto',
  nowIndicator: true,
  editable: false,
  selectable: true
});

// Optionnel : Chargement dynamique si beaucoup de voyages
const loadVoyages = async () => {
  try {
    const response = await axios.get('/api/voyages/calendar');
    calendar.value.getApi().removeAllEvents();
    calendar.value.getApi().addEventSource(response.data);
  } catch (error) {
    console.error('Erreur chargement voyages:', error);
  }
};

onMounted(() => {
  // Rafraîchir les voyages toutes les 5 minutes
  setInterval(loadVoyages, 300000);
});
</script>

<style>
.fc {
  @apply h-full;
}

.fc-event {
  @apply cursor-pointer;
  @apply border-0 !important;
  @apply shadow-xs;
}

.fc-daygrid-event-dot {
  @apply hidden;
}

.fc-event-title {
  @apply font-medium;
  @apply truncate;
}

.fc-event-time {
  @apply text-xs;
  @apply mt-1;
}

.fc-toolbar-title {
  @apply text-lg font-bold text-gray-800;
}

.fc-col-header-cell {
  @apply bg-blue-50;
  @apply py-2;
}

.fc-day-today {
  @apply bg-blue-50/50;
}
</style>
