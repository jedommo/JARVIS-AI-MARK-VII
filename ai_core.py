from interpreter import interpreter

class AICore:
    def __init__(self, memory):
        self.memory = memory
        interpreter.llm.api_key = "YOUR_API_KEY"
        interpreter.llm.api_base = "https://openrouter.ai/api/v1"
        interpreter.llm.model = "openai/gpt-oss-120b:free"
        interpreter.api_key = interpreter.llm.api_key
        interpreter.auto_run = True

    def handle_command(self, text):
        try:
            # استخدام الذاكرة المضافة
            context = self.memory.get_context()
            interpreter.system_message = f"You are JARVIS. Context: {context}"
            
            full_response = ""
            for chunk in interpreter.chat(text):
                if 'content' in chunk:
                    full_response += chunk['content']
            
            response = full_response if full_response else "DONE, SIR."
            self.memory.save(text, response)
            return response
        except Exception as e:
            # عرض الخطأ في الكونسول فقط وإرسال رسالة نظيفة للواجهة
            print(f"Debug Error: {e}")
            return "SYSTEM ERROR: CHECK API KEY OR NETWORK."