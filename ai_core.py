from interpreter import interpreter

class AICore:
    def __init__(self, memory):
        self.memory = memory
        interpreter.llm.api_key = "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"
        interpreter.llm.api_base = "https://openrouter.ai/api/v1"
        interpreter.llm.model = "openai/gpt-oss-120b:free"
        interpreter.api_key = interpreter.llm.api_key
        interpreter.auto_run = True

    def handle_command(self, text):
        try:
            context = self.memory.get_context()
            interpreter.system_message = f"You are JARVIS. Use this context from memory: {context}"
            
            full_response = ""
            for chunk in interpreter.chat(text):
                if 'content' in chunk:
                    full_response += chunk['content']
            
            response = full_response if full_response else "REQUEST COMPLETE."
            self.memory.save(text, response) #
            return response
        except Exception as e:
            return f"DIAGNOSTIC ERROR: {str(e)}"