<script setup>
defineProps({
    modelValue: [String, Number],
    options: Array,
    placeholder: String,
    disabled: Boolean,
    error: String
});

const emit = defineEmits(['update:modelValue']);
</script>

<template>
    <select
        :value="modelValue"
        @change="emit('update:modelValue', $event.target.value)"
        :disabled="disabled"
        class="form-select block w-full border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm"
        :class="{ 'border-red-500': error }"
    >
        <option value="" disabled>{{ placeholder }}</option>
        <option v-for="option in options" :key="option.value" :value="option.value">
            {{ option.label }}
        </option>
    </select>
</template>
