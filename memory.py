import os
import json
from datetime import datetime

MEMORY_FILE = "memory.json"

class Memory:
    def __init__(self):
        if not os.path.exists(MEMORY_FILE):
            with open(MEMORY_FILE, 'w', encoding='utf-8') as f:
                json.dump([], f)

    def save(self, user_input, ai_response):
        try:
            with open(MEMORY_FILE, 'r+', encoding='utf-8') as f:
                data = json.load(f)
                entry = {
                    "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                    "user": user_input,
                    "jarvis": ai_response
                }
                data.append(entry)
                if len(data) > 50:
                    data = data[-50:]
                f.seek(0)
                json.dump(data, f, indent=4, ensure_ascii=False)
                f.truncate()
        except Exception as e:
            print(f"Memory Save Error: {e}")

    def get_context(self):
        try:
            with open(MEMORY_FILE, 'r', encoding='utf-8') as f:
                data = json.load(f)
                context = ""
                for entry in data[-5:]:
                    context += f"User: {entry['user']}\nJarvis: {entry['jarvis']}\n"
                return context
        except:
            return ""