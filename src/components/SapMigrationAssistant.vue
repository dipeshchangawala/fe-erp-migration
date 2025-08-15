<template>
  <div
    class="chat-app-container"
    style="
      display: flex;
      flex-direction: column;
      height: 100vh;
      width: 100%;
      max-width: 900px;
      margin: 0 auto;
      background-color: #ffffff;
      box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1);
      border-radius: 16px;
      overflow: hidden;
    "
  >
    <header
      class="app-header"
      style="
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 1rem 1.5rem;
        border-bottom: 1px solid #e5e7eb;
        font-size: 1.25rem;
        font-weight: 600;
        background-color: #ffffff;
        color: #111827;
      "
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="28"
        height="28"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
        style="color: #4f46e5"
      >
        <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"></path>
      </svg>
      SAP Migration Assistant
    </header>

    <nav
      class="tag-suggestions"
      style="
        padding: 1rem 1.5rem 0.5rem;
        display: flex;
        flex-wrap: wrap;
        gap: 0.75rem;
        border-bottom: 1px solid #e5e7eb;
        background-color: #ffffff;
      "
    >
      <button
        v-for="template in promptTemplates"
        :key="template.key"
        class="tag-btn"
        :class="{ active: activeTemplate === template.key }"
        @click="handleTagClick(template.key)"
        :data-template="template.key"
        style="
          padding: 0.5rem 1rem;
          border: 1px solid #e5e7eb;
          border-radius: 9999px;
          background-color: #f3f4f6;
          color: #6b7280;
          font-size: 0.9rem;
          font-weight: 500;
          cursor: pointer;
          transition: all 0.2s ease-in-out;
        "
      >
        {{ template.name }}
      </button>
    </nav>

    <main
      class="chat-container"
      style="
        flex-grow: 1;
        display: flex;
        flex-direction: column;
        overflow: hidden;
        background-color: #ffffff;
      "
    >
      <div
        class="chat-window"
        ref="chatWindow"
        style="
          flex-grow: 1;
          padding: 2rem 1.5rem;
          overflow-y: auto;
          display: flex;
          flex-direction: column;
          gap: 1.5rem;
          background-color: #ffffff;
        "
      >
        <div
          v-for="(message, index) in chatMessages"
          :key="index"
          class="chat-message"
          :class="message.class"
          style="
            max-width: 75%;
            padding: 0.85rem 1.25rem;
            border-radius: 20px;
            word-wrap: break-word;
            box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            display: flex;
            flex-direction: column;
          "
        >
          <div v-html="message.content"></div>
        </div>
        <div
          v-if="isTyping"
          class="chat-message assistant-message typing-indicator"
          style="
            display: flex;
            align-items: center;
            gap: 5px;
            padding: 0.85rem 1.25rem;
            align-self: flex-start;
            margin-right: auto;
          "
        >
          <span></span>
          <span></span>
          <span></span>
        </div>
      </div>

      <div class="prompt-area" style="padding: 1rem 1.5rem 1.5rem; background-color: #ffffff">
        <div
          class="prompt-wrapper"
          style="
            position: relative;
            background-color: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            padding: 1rem;
            padding-right: 4.5rem;
            box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
          "
        >
          <div
            ref="promptContent"
            class="prompt-content"
            contenteditable="true"
            @input="updateSendButtonState"
            @keydown="handleKeyDown"
            style="
              min-height: 56px;
              max-height: 300px;
              overflow-y: auto;
              outline: none;
              font-size: 1rem;
              line-height: 1.7;
              font-family: inherit;
            "
          ></div>
          <div
            class="prompt-actions"
            style="
              position: absolute;
              bottom: 0.75rem;
              right: 0.75rem;
              display: flex;
              gap: 0.5rem;
              align-items: center;
            "
          >
            <button
              class="action-btn"
              id="clear-btn"
              title="Clear Input"
              @click="handleClear"
              style="
                height: 36px;
                width: 36px;
                border-radius: 8px;
                background-color: transparent;
                color: #6b7280;
                border: none;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
              "
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="20"
                height="20"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
              >
                <polyline points="3 6 5 6 21 6"></polyline>
                <path
                  d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"
                ></path>
                <line x1="10" y1="11" x2="10" y2="17"></line>
                <line x1="14" y1="11" x2="14" y2="17"></line>
              </svg>
            </button>
            <button
              class="action-btn"
              id="send-btn"
              :disabled="!canSend"
              title="Send Message"
              @click="handleSend"
              style="
                height: 48px;
                width: 48px;
                border-radius: 16px;
                background-color: #4f46e5;
                color: #ffffff;
                border: none;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
              "
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
              >
                <line x1="22" y1="2" x2="11" y2="13"></line>
                <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
              </svg>
            </button>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick } from 'vue'

interface PromptTemplate {
  key: string
  name: string
  connections: string[]
  groups: string[]
}

interface ChatMessage {
  content: string
  class: string
}

const chatWindow = ref<HTMLElement>()
const promptContent = ref<HTMLElement>()
const activeTemplate = ref<string | null>(null)
const isTyping = ref(false)
const canSend = ref(false)
const chatMessages = ref<ChatMessage[]>([
  {
    content:
      'Hello! I am the SAP Migration Assistant. Please select a transfer type from the tags above to begin.',
    class: 'assistant-message',
  },
])

const promptTemplates: PromptTemplate[] = [
  {
    key: 'purchase',
    name: 'Purchase Transfer',
    connections: ['ECC_DE', 'S4H_US', 'BYD_UK'],
    groups: ['GRP_FIN', 'GRP_LOG', 'GRP_HR'],
  },
  {
    key: 'sales',
    name: 'Sales Transfer',
    connections: ['CRM_EU', 'S4H_US', 'ECC_JP'],
    groups: ['GRP_SALES', 'GRP_DIST', 'GRP_BILLING'],
  },
  {
    key: 'production',
    name: 'Production Transfers',
    connections: ['MES_DE', 'S4H_PROD', 'APO_CN'],
    groups: ['GRP_MFG', 'GRP_QA', 'GRP_PLAN'],
  },
  {
    key: 'customers',
    name: 'Customers Transfer',
    connections: ['CRM_US', 'MDG_GLOBAL', 'ECC_DE'],
    groups: ['GRP_CUST_A', 'GRP_CUST_B', 'GRP_CUST_C'],
  },
]

const createSelect = (id: string, options: string[]): string => {
  const optionsHtml = options.map((opt) => `<option value="${opt}">${opt}</option>`).join('')
  return `<select id="${id}" class="prompt-select">${optionsHtml}</select>`
}

const createInput = (id: string, type: string, placeholder: string): string => {
  return `<input type="${type}" id="${id}" class="prompt-input" placeholder="${placeholder}">`
}

const generatePromptHtml = (key: string): string => {
  const template = promptTemplates.find((t) => t.key === key)
  if (!template) return ''

  return `I want to perform a <strong>${template.name}</strong>.<br>Please use the connection ${createSelect(`${key}-connection`, template.connections)} and the business object group ${createSelect(`${key}-group`, template.groups)}.<br><br>The migration period is from ${createInput(`${key}-from-date`, 'date', 'Start Date')} to ${createInput(`${key}-to-date`, 'date', 'End Date')}.<br><br><strong>Filter Criteria:</strong><br>• Document No: ${createInput(`${key}-doc-from`, 'number', 'e.g. 1000')} to ${createInput(`${key}-doc-to`, 'number', 'e.g. 2000')}<br>• Company Code: ${createInput(`${key}-comp-from`, 'number', 'e.g. 100')} to ${createInput(`${key}-comp-to`, 'number', 'e.g. 200')}<br>• Tax ID: ${createInput(`${key}-tax-from`, 'number', 'e.g. 50')} to ${createInput(`${key}-tax-to`, 'number', 'e.g. 100')}<br>• Language Key: ${createInput(`${key}-lang-from`, 'text', 'e.g. EN')} to ${createInput(`${key}-lang-to`, 'text', 'e.g. DE')}`
}

const scrollToBottom = () => {
  if (chatWindow.value) {
    chatWindow.value.scrollTop = chatWindow.value.scrollHeight
  }
}

const updateSendButtonState = () => {
  if (promptContent.value) {
    canSend.value =
      promptContent.value.textContent?.trim() !== '' || promptContent.value.children.length > 0
  }
}

const displayMessage = (message: string, sender: 'user' | 'assistant', isError = false) => {
  let messageClass = `${sender}-message`
  if (isError) {
    messageClass = 'error-message'
  }

  chatMessages.value.push({
    content: message,
    class: messageClass,
  })

  nextTick(() => {
    scrollToBottom()
  })
}

const toggleTypingIndicator = (show: boolean) => {
  isTyping.value = show
  if (show) {
    nextTick(() => {
      scrollToBottom()
    })
  }
}

const handleTagClick = (templateKey: string) => {
  // Allow toggling off a template
  if (activeTemplate.value === templateKey) {
    handleClear()
    return
  }

  activeTemplate.value = templateKey

  if (promptContent.value) {
    promptContent.value.innerHTML = generatePromptHtml(templateKey)
    updateSendButtonState()
    promptContent.value.focus()
  }
}

const handleClear = () => {
  if (promptContent.value) {
    promptContent.value.innerHTML = ''
  }
  activeTemplate.value = null
  updateSendButtonState()
}

const collectPromptData = () => {
  if (
    !activeTemplate.value &&
    (!promptContent.value || promptContent.value.textContent?.trim() === '')
  ) {
    return null
  }

  // If it's a free-form query (no template selected)
  if (!activeTemplate.value && promptContent.value) {
    return {
      html: `<pre>${promptContent.value.textContent}</pre>`,
      text: promptContent.value.textContent?.replace(/\s+/g, ' ').trim() || '',
    }
  }

  if (!promptContent.value) return null

  const contentClone = promptContent.value.cloneNode(true) as HTMLElement
  const textClone = promptContent.value.cloneNode(true) as HTMLElement

  // Iterate over the LIVE elements to get their current values,
  // then find and replace the corresponding elements in the clones.
  promptContent.value.querySelectorAll('select, input').forEach((liveElement) => {
    const value =
      (liveElement as HTMLInputElement | HTMLSelectElement).value ||
      `[${(liveElement as HTMLInputElement).placeholder || 'empty'}]`

    // Update the clone for HTML display
    const clonedContentElement = contentClone.querySelector('#' + liveElement.id)
    if (clonedContentElement) {
      const valueNode = document.createElement('strong')
      valueNode.textContent = value
      clonedContentElement.parentNode?.replaceChild(valueNode, clonedContentElement)
    }

    // Update the clone for the plain text payload
    const clonedTextElement = textClone.querySelector('#' + liveElement.id)
    if (clonedTextElement) {
      clonedTextElement.parentNode?.replaceChild(document.createTextNode(value), clonedTextElement)
    }
  })

  return {
    html: contentClone.innerHTML.replace(/<br>/g, '\n'), // Keep line breaks clean
    text: textClone.textContent?.replace(/\s\s+/g, ' ').trim() || '',
  }
}

const makeApiCall = async (promptText: string) => {
  toggleTypingIndicator(true)
  canSend.value = false

  // NOTE: Ensure your local server is running and accessible at this address.
  const API_BASE_URL = import.meta.env.VITE_API_BASE_URL
  const PROMPT_URL = API_BASE_URL + '/api/v1/process-prompt'
  const payload = { prompt: promptText }

  try {
    const response = await fetch(PROMPT_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    })

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status} ${response.statusText}`)
    }

    const data = await response.json()

    // Format the response for better readability
    let formattedResponse = `${data.message}\n\n`
    formattedResponse += `<strong>Endpoint Targeted:</strong> ${data.endpoint}\n`
    formattedResponse += `<strong>Parameters Received:</strong>\n`
    // Using JSON.stringify with pretty-printing inside a <pre> tag
    formattedResponse += `<pre>${JSON.stringify(data.parameters, null, 2)}</pre>`

    displayMessage(formattedResponse, 'assistant')
  } catch (error) {
    console.error('API Call Failed:', error)
    const errorMessage = `Failed to process your request.\n<strong>Error:</strong> ${error instanceof Error ? error.message : 'Unknown error'}\n\nPlease check if the backend service is running correctly.`
    displayMessage(errorMessage, 'assistant', true)
  } finally {
    toggleTypingIndicator(false)
    updateSendButtonState() // Re-enable send button based on prompt state
  }
}

const handleSend = () => {
  const promptData = collectPromptData()
  if (!promptData || !promptData.text) return

  displayMessage(promptData.html, 'user')
  makeApiCall(promptData.text)

  // Clear the prompt after sending for a classic chat experience
  handleClear()
}

const handleKeyDown = (e: KeyboardEvent) => {
  if (e.key === 'Enter' && !e.shiftKey) {
    e.preventDefault() // Prevent new line
    handleSend() // Trigger send
  }
}

async function getThreads() {
  const API_BASE_URL = import.meta.env.VITE_API_BASE_URL
  const thread_url = API_BASE_URL + '/api/v1/threads/search'

  try {
    const response = await fetch(thread_url, {
      method: 'GET',
      headers: { 'Content-Type': 'application/json' },
    })

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status} ${response.statusText}`)
    }

    const data = await response.json()
    console.log(data)
  } catch (error) {
    console.log(error)
  }
}

onMounted(async () => {
  console.log('SapMigrationAssistant component mounted')
  scrollToBottom()
  // Ensure styles are applied
  if (chatWindow.value) {
    console.log('Chat window element found:', chatWindow.value)
    console.log('Chat window classes:', chatWindow.value.className)
    console.log('Chat window computed styles:', window.getComputedStyle(chatWindow.value))
  }
  if (promptContent.value) {
    console.log('Prompt content element found:', promptContent.value)
    console.log('Prompt content classes:', promptContent.value.className)
    console.log('Prompt content computed styles:', window.getComputedStyle(promptContent.value))
  }

  // Check if CSS is loaded
  const computedStyle = window.getComputedStyle(document.body)
  console.log('Body background color:', computedStyle.backgroundColor)
  console.log('Body font family:', computedStyle.fontFamily)

  // Check if our CSS variables are loaded
  const rootStyle = window.getComputedStyle(document.documentElement)
  console.log('CSS Variables loaded:', {
    bgBody: rootStyle.getPropertyValue('--bg-body'),
    bgMain: rootStyle.getPropertyValue('--bg-main'),
    textPrimary: rootStyle.getPropertyValue('--text-primary'),
  })

  // Force a reflow to ensure styles are applied
  document.body.offsetHeight

  await getThreads()
})
</script>
