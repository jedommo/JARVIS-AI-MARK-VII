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
                data.append({
                    "time": datetime.now().strftime("%H:%M"),
                    "user": user_input,
                    "jarvis": ai_response
                })
                if len(data) > 50: data = data[-50:]
                f.seek(0)
                json.dump(data, f, indent=4, ensure_ascii=False)
                f.truncate()
        except: pass

    def get_context(self):
        try:
            with open(MEMORY_FILE, 'r', encoding='utf-8') as f:
                data = json.load(f)
                return "\n".join([f"U: {e['user']} | J: {e['jarvis']}" for e in data[-3:]])
        except: return ""