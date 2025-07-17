<script setup>
defineProps({
    modelValue: Array,
    options: Array,
    error: String
});

const emit = defineEmits(['update:modelValue']);

const toggleOption = (optionValue) => {
    const newValue = [...modelValue];
    const index = newValue.indexOf(optionValue);

    if (index === -1) {
        newValue.push(optionValue);
    } else {
        newValue.splice(index, 1);
    }

    emit('update:modelValue', newValue);
};
</script>

<template>
    <div class="space-y-2">
        <div v-for="option in options" :key="option.value" class="flex items-center">
            <input
                type="checkbox"
                :id="option.value"
                :checked="modelValue.includes(option.value)"
                @change="toggleOption(option.value)"
                class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
                :class="{ 'border-red-500': error }"
            >
            <label :for="option.value" class="ml-2 block text-sm text-gray-700">
                {{ option.label }}
            </label>
        </div>
    </div>
</template>
