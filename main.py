import sys
import os
import threading
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot, Signal

from voice_engine import VoiceEngine
from ai_core import AICore
from memory import Memory

class Bridge(QObject):
    updateState = Signal(str)
    updateText = Signal(str)

    def __init__(self):
        super().__init__()
        self.voice = VoiceEngine()
        self.memory = Memory()
        self.ai = AICore(self.memory)

    @Slot()
    def start_listening(self):
        threading.Thread(target=self.run_assistant_voice, daemon=True).start()

    @Slot(str)
    def handle_text_input(self, text):
        if text.strip():
            threading.Thread(target=self.run_assistant_text, args=(text,), daemon=True).start()

    def run_assistant_voice(self):
        self.updateState.emit("listening")
        self.updateText.emit("LISTENING...")
        text = self.voice.listen()
        if not text:
            self.updateText.emit("NO VOICE DETECTED")
            self.updateState.emit("idle")
            return
        self.process_command(text)

    def run_assistant_text(self, text):
        self.process_command(text)

    def process_command(self, text):
        self.updateState.emit("processing")
        self.updateText.emit("THINKING...")
        response = self.ai.handle_command(text)
        self.updateText.emit(response)
        self.updateState.emit("speaking")
        self.voice.speak(response)
        self.updateState.emit("idle")

if __name__ == "__main__":
    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.clearComponentCache()
    bridge = Bridge()
    engine.rootContext().setContextProperty("bridge", bridge)
    current_dir = os.path.dirname(os.path.abspath(__file__))
    engine.load(os.path.join(current_dir, "main.qml"))
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())