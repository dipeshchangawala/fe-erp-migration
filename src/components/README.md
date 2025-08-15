# SAP Migration Assistant Component

This Vue.js component replicates the functionality of the original HTML file with improved structure and maintainability.

## Features

- **Template-based prompts**: Pre-configured templates for different migration types
- **Dynamic form generation**: Automatically creates form inputs based on selected templates
- **Real-time chat interface**: Interactive chat with typing indicators
- **API integration**: Connects to backend services for processing prompts
- **Responsive design**: Mobile-friendly interface
- **TypeScript support**: Full type safety and IntelliSense

## Usage

```vue
<template>
  <SapMigrationAssistant />
</template>

<script setup lang="ts">
import SapMigrationAssistant from './components/SapMigrationAssistant.vue'
</script>
```

## Component Structure

- **Template**: Clean, semantic HTML with Vue.js directives
- **Script**: Composition API with TypeScript interfaces
- **Styles**: External CSS file for maintainability

## API Configuration

The component expects a backend API at `http://0.0.0.0:8001/process-prompt`. Update the `API_URL` constant in the component if your backend is hosted elsewhere.

## Customization

- **Templates**: Modify the `promptTemplates` array to add/remove migration types
- **Styling**: Update the external CSS file (`src/assets/sap-migration.css`)
- **API endpoints**: Modify the `makeApiCall` function for different backend services

## Dependencies

- Vue 3.5+
- TypeScript
- No additional npm packages required
