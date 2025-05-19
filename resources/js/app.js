import './bootstrap';
// import 'assets/js/bootstrap.bundle.min.js'
import { createApp, h } from 'vue'
import { createInertiaApp } from '@inertiajs/vue3'
import { InertiaProgress } from '@inertiajs/progress'
import { ZiggyVue } from 'ziggy-js'
import VueSweetalert2 from 'vue-sweetalert2'
import 'sweetalert2/dist/sweetalert2.min.css'

const pages = import.meta.glob('./Pages/**/*.vue');

createInertiaApp({
  resolve: name => {
    const page = pages[`./Pages/${name}.vue`];
    if (!page) throw new Error(`Page not found: ./Pages/${name}.vue`);
    return page();
  },
  setup({ el, App, props, plugin }) {
    createApp({ render: () => h(App, props) })
      .use(plugin)
      .use(VueSweetalert2)
      .use(ZiggyVue)
      .mount(el);
  },
});

InertiaProgress.init();
