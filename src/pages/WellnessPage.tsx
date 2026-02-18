import { useState } from "react";
import {
  HeartPulse, Smile, Frown, Meh, Sun, Cloud, CloudRain,
  Sparkles, MessageCircle, Play, Wind, TreePine, Send,
  TrendingUp, Calendar, Heart, Shield
} from "lucide-react";

const moods = [
  { icon: Sun, label: "Great", color: "text-amber-500", bg: "bg-amber-50 border-amber-200 hover:bg-amber-100", value: 5 },
  { icon: Smile, label: "Good", color: "text-emerald-500", bg: "bg-emerald-50 border-emerald-200 hover:bg-emerald-100", value: 4 },
  { icon: Meh, label: "Okay", color: "text-blue-500", bg: "bg-blue-50 border-blue-200 hover:bg-blue-100", value: 3 },
  { icon: Cloud, label: "Low", color: "text-gray-500", bg: "bg-gray-50 border-gray-200 hover:bg-gray-100", value: 2 },
  { icon: CloudRain, label: "Rough", color: "text-violet-500", bg: "bg-violet-50 border-violet-200 hover:bg-violet-100", value: 1 },
];

const weekData = [
  { day: "Mon", mood: 4, label: "Good" },
  { day: "Tue", mood: 3, label: "Okay" },
  { day: "Wed", mood: 5, label: "Great" },
  { day: "Thu", mood: 4, label: "Good" },
  { day: "Fri", mood: 2, label: "Low" },
  { day: "Sat", mood: 4, label: "Good" },
  { day: "Sun", mood: 5, label: "Great" },
];

const treeHolePosts = [
  { text: "Feeling overwhelmed with assignments this week. Anyone else?", time: "2 hours ago", reactions: 12, replies: 5 },
  { text: "Had a great study session today! Sometimes things click and it feels amazing.", time: "5 hours ago", reactions: 24, replies: 8 },
  { text: "Missing home a lot today. International student life is tough sometimes.", time: "Yesterday", reactions: 31, replies: 15 },
  { text: "Just passed my presentation that I was so anxious about! Proud of myself.", time: "Yesterday", reactions: 45, replies: 12 },
];

const relaxResources = [
  { title: "5-Minute Breathing Exercise", duration: "5 min", type: "Breathing", icon: Wind, color: "from-cyan-500 to-blue-500" },
  { title: "Nature Sounds - Forest Rain", duration: "30 min", type: "Audio", icon: TreePine, color: "from-emerald-500 to-green-600" },
  { title: "Progressive Muscle Relaxation", duration: "10 min", type: "Guide", icon: HeartPulse, color: "from-rose-500 to-pink-600" },
  { title: "Mindful Meditation for Students", duration: "15 min", type: "Video", icon: Play, color: "from-violet-500 to-purple-600" },
];

export function WellnessPage() {
  const [tab, setTab] = useState<"checkin" | "treehole" | "chat" | "relax">("checkin");
  const [selectedMood, setSelectedMood] = useState<number | null>(null);
  const [journalEntry, setJournalEntry] = useState("");
  const [chatMessages, setChatMessages] = useState<Array<{ role: "ai" | "user"; text: string }>>([
    { role: "ai", text: "Hi there! 👋 I'm your AI wellness companion. How are you feeling today? I'm here to listen and support you." },
  ]);
  const [chatInput, setChatInput] = useState("");
  const [treeHoleInput, setTreeHoleInput] = useState("");

  const sendMessage = () => {
    if (!chatInput.trim()) return;
    const userMsg = chatInput;
    setChatMessages(prev => [...prev, { role: "user" as const, text: userMsg }]);
    setChatInput("");
    setTimeout(() => {
      setChatMessages(prev => [...prev, {
        role: "ai" as const,
        text: "I hear you, and it's completely valid to feel that way. University life can be really challenging. Remember, it's okay to take things one step at a time. Would you like to talk more about what's been on your mind, or would you prefer some relaxation techniques? 💙"
      }]);
    }, 1000);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Wellness & Mental Health</h1>
          <p className="text-gray-500 mt-1">Track your mood, share anonymously, and find support.</p>
        </div>
        <div className="flex items-center gap-3">
          <div className="px-3 py-1.5 bg-emerald-50 text-emerald-700 text-sm rounded-lg font-medium flex items-center gap-1.5">
            <HeartPulse className="w-4 h-4" />
            Wellness Score: 85%
          </div>
          <div className="px-3 py-1.5 bg-amber-50 text-amber-700 text-sm rounded-lg font-medium flex items-center gap-1.5">
            <TrendingUp className="w-4 h-4" />
            7-day streak
          </div>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex gap-1 bg-gray-100 rounded-xl p-1 w-fit overflow-x-auto">
        {([
          { id: "checkin" as const, label: "Mood Check-in", icon: Smile },
          { id: "treehole" as const, label: "Tree Hole", icon: Shield },
          { id: "chat" as const, label: "AI Companion", icon: MessageCircle },
          { id: "relax" as const, label: "Relax", icon: Wind },
        ]).map((t) => (
          <button
            key={t.id}
            onClick={() => setTab(t.id)}
            className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition-all whitespace-nowrap ${
              tab === t.id
                ? "bg-white text-indigo-700 shadow-sm"
                : "text-gray-600 hover:text-gray-900"
            }`}
          >
            <t.icon className="w-4 h-4" />
            {t.label}
          </button>
        ))}
      </div>

      {tab === "checkin" && (
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2 space-y-4">
            {/* Mood Selection */}
            <div className="bg-white rounded-xl border border-gray-200 p-6">
              <h2 className="font-semibold text-gray-900 mb-4 flex items-center gap-2">
                <Calendar className="w-5 h-5 text-indigo-600" />
                How are you feeling today?
              </h2>
              <div className="grid grid-cols-5 gap-3 mb-6">
                {moods.map((mood) => (
                  <button
                    key={mood.value}
                    onClick={() => setSelectedMood(mood.value)}
                    className={`flex flex-col items-center gap-2 p-4 rounded-xl border-2 transition-all ${
                      selectedMood === mood.value
                        ? `${mood.bg} scale-105 shadow-md`
                        : "border-gray-100 hover:border-gray-200"
                    }`}
                  >
                    <mood.icon className={`w-8 h-8 ${mood.color}`} />
                    <span className="text-xs font-medium text-gray-700">{mood.label}</span>
                  </button>
                ))}
              </div>

              {selectedMood && (
                <div className="space-y-3">
                  <textarea
                    value={journalEntry}
                    onChange={(e) => setJournalEntry(e.target.value)}
                    placeholder="What's on your mind? (Optional - your journal is private)"
                    className="w-full p-4 bg-gray-50 border border-gray-200 rounded-xl text-sm resize-none h-24 outline-none focus:border-indigo-300 focus:ring-2 focus:ring-indigo-100 transition-all"
                  />
                  <button className="px-6 py-2.5 bg-indigo-600 text-white text-sm font-medium rounded-xl hover:bg-indigo-700 transition-colors">
                    Save Check-in ✨
                  </button>
                </div>
              )}
            </div>

            {/* Weekly Chart */}
            <div className="bg-white rounded-xl border border-gray-200 p-6">
              <h2 className="font-semibold text-gray-900 mb-4">This Week's Mood</h2>
              <div className="flex items-end gap-3 h-48">
                {weekData.map((day) => (
                  <div key={day.day} className="flex-1 flex flex-col items-center gap-2">
                    <div className="relative w-full flex-1 flex items-end">
                      <div
                        className={`w-full rounded-t-lg transition-all ${
                          day.mood >= 4 ? "bg-gradient-to-t from-emerald-500 to-emerald-400" :
                          day.mood === 3 ? "bg-gradient-to-t from-blue-500 to-blue-400" :
                          "bg-gradient-to-t from-violet-500 to-violet-400"
                        }`}
                        style={{ height: `${(day.mood / 5) * 100}%` }}
                      />
                    </div>
                    <div className="text-xs text-gray-500 font-medium">{day.day}</div>
                  </div>
                ))}
              </div>
              <div className="flex items-center justify-center gap-6 mt-4">
                <div className="flex items-center gap-1.5 text-xs text-gray-500">
                  <div className="w-3 h-3 rounded bg-emerald-400" /> Good/Great
                </div>
                <div className="flex items-center gap-1.5 text-xs text-gray-500">
                  <div className="w-3 h-3 rounded bg-blue-400" /> Okay
                </div>
                <div className="flex items-center gap-1.5 text-xs text-gray-500">
                  <div className="w-3 h-3 rounded bg-violet-400" /> Low/Rough
                </div>
              </div>
            </div>
          </div>

          {/* Sidebar Stats */}
          <div className="space-y-4">
            <div className="bg-gradient-to-br from-emerald-50 to-teal-50 rounded-xl border border-emerald-100 p-5">
              <div className="text-center">
                <div className="w-20 h-20 rounded-full bg-gradient-to-br from-emerald-400 to-teal-500 flex items-center justify-center mx-auto mb-3">
                  <span className="text-2xl font-bold text-white">85%</span>
                </div>
                <h3 className="font-semibold text-emerald-900">Wellness Score</h3>
                <p className="text-sm text-emerald-700 mt-1">+12% from last month</p>
              </div>
              <div className="mt-4 space-y-2">
                {[
                  { label: "Sleep Quality", value: 80 },
                  { label: "Stress Level", value: 35 },
                  { label: "Social Activity", value: 70 },
                  { label: "Physical Activity", value: 60 },
                ].map((metric) => (
                  <div key={metric.label}>
                    <div className="flex justify-between text-xs mb-1">
                      <span className="text-emerald-700">{metric.label}</span>
                      <span className="font-medium text-emerald-800">{metric.value}%</span>
                    </div>
                    <div className="w-full bg-emerald-200/50 rounded-full h-1.5">
                      <div className="h-1.5 rounded-full bg-emerald-500" style={{ width: `${metric.value}%` }} />
                    </div>
                  </div>
                ))}
              </div>
            </div>
            <div className="bg-white rounded-xl border border-gray-200 p-5">
              <h3 className="font-semibold text-gray-900 mb-3 text-sm">Quick Actions</h3>
              <div className="space-y-2">
                {[
                  { label: "Breathing Exercise", emoji: "🫁" },
                  { label: "Talk to AI", emoji: "💬" },
                  { label: "Write in Journal", emoji: "📝" },
                  { label: "Emergency Help", emoji: "🆘" },
                ].map((action) => (
                  <button key={action.label} className="w-full flex items-center gap-3 p-3 bg-gray-50 rounded-lg hover:bg-indigo-50 transition-colors text-sm text-gray-700 hover:text-indigo-700">
                    <span className="text-lg">{action.emoji}</span>
                    {action.label}
                  </button>
                ))}
              </div>
            </div>
          </div>
        </div>
      )}

      {tab === "treehole" && (
        <div className="max-w-2xl mx-auto space-y-4">
          <div className="bg-gradient-to-r from-violet-50 to-indigo-50 rounded-xl border border-violet-100 p-5">
            <div className="flex items-start gap-3">
              <Shield className="w-10 h-10 text-violet-600 shrink-0 p-2 bg-violet-100 rounded-xl" />
              <div>
                <h3 className="font-semibold text-violet-900">Anonymous Safe Space 🌳</h3>
                <p className="text-sm text-violet-700/80 mt-1">Share your thoughts anonymously. All posts are reviewed by AI for safety. Be kind and supportive.</p>
              </div>
            </div>
          </div>

          {/* Post input */}
          <div className="bg-white rounded-xl border border-gray-200 p-4">
            <div className="flex items-start gap-3">
              <div className="w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center text-gray-500 shrink-0">
                <Frown className="w-5 h-5" />
              </div>
              <div className="flex-1">
                <textarea
                  value={treeHoleInput}
                  onChange={(e) => setTreeHoleInput(e.target.value)}
                  placeholder="What's on your mind? (Anonymous)"
                  className="w-full bg-transparent text-sm resize-none h-16 outline-none placeholder-gray-400"
                />
                <div className="flex justify-end">
                  <button className="px-4 py-1.5 bg-indigo-600 text-white text-sm rounded-lg hover:bg-indigo-700 transition-colors">
                    Share Anonymously
                  </button>
                </div>
              </div>
            </div>
          </div>

          {/* Posts */}
          {treeHolePosts.map((post, i) => (
            <div key={i} className="bg-white rounded-xl border border-gray-200 p-5">
              <div className="flex items-center gap-2 mb-3">
                <div className="w-8 h-8 rounded-full bg-gradient-to-br from-gray-300 to-gray-400 flex items-center justify-center text-white text-xs">
                  🌱
                </div>
                <span className="text-sm font-medium text-gray-500">Anonymous</span>
                <span className="text-xs text-gray-400">· {post.time}</span>
              </div>
              <p className="text-gray-700 leading-relaxed mb-4">{post.text}</p>
              <div className="flex items-center gap-4">
                <button className="flex items-center gap-1.5 text-sm text-gray-500 hover:text-rose-500 transition-colors">
                  <Heart className="w-4 h-4" /> {post.reactions}
                </button>
                <button className="flex items-center gap-1.5 text-sm text-gray-500 hover:text-indigo-500 transition-colors">
                  <MessageCircle className="w-4 h-4" /> {post.replies}
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      {tab === "chat" && (
        <div className="max-w-2xl mx-auto">
          <div className="bg-white rounded-xl border border-gray-200 overflow-hidden" style={{ height: "calc(100vh - 280px)", minHeight: "500px" }}>
            {/* Chat header */}
            <div className="px-5 py-3 border-b border-gray-100 bg-gradient-to-r from-indigo-50 to-violet-50 flex items-center gap-3">
              <div className="w-10 h-10 rounded-full bg-gradient-to-br from-indigo-500 to-violet-500 flex items-center justify-center">
                <Sparkles className="w-5 h-5 text-white" />
              </div>
              <div>
                <div className="font-semibold text-gray-900 text-sm">AI Wellness Companion</div>
                <div className="text-xs text-green-600 flex items-center gap-1">
                  <div className="w-2 h-2 rounded-full bg-green-500" />
                  Powered by Gemini
                </div>
              </div>
            </div>

            {/* Messages */}
            <div className="flex-1 overflow-y-auto p-5 space-y-4" style={{ height: "calc(100% - 130px)" }}>
              {chatMessages.map((msg, i) => (
                <div key={i} className={`flex ${msg.role === "user" ? "justify-end" : "justify-start"}`}>
                  <div className={`max-w-[80%] px-4 py-3 rounded-2xl text-sm leading-relaxed ${
                    msg.role === "user"
                      ? "bg-indigo-600 text-white rounded-br-md"
                      : "bg-gray-100 text-gray-800 rounded-bl-md"
                  }`}>
                    {msg.text}
                  </div>
                </div>
              ))}
            </div>

            {/* Input */}
            <div className="p-4 border-t border-gray-100">
              <div className="flex items-center gap-2">
                <input
                  type="text"
                  value={chatInput}
                  onChange={(e) => setChatInput(e.target.value)}
                  onKeyDown={(e) => e.key === "Enter" && sendMessage()}
                  placeholder="Type your message..."
                  className="flex-1 px-4 py-2.5 bg-gray-100 rounded-xl text-sm outline-none focus:bg-gray-50 focus:ring-2 focus:ring-indigo-100 transition-all"
                />
                <button
                  onClick={sendMessage}
                  className="p-2.5 bg-indigo-600 text-white rounded-xl hover:bg-indigo-700 transition-colors"
                >
                  <Send className="w-5 h-5" />
                </button>
              </div>
              <p className="text-xs text-gray-400 mt-2 text-center">
                This AI companion is not a replacement for professional help. If you're in crisis, please call 03-7956 8145 (UM Counseling).
              </p>
            </div>
          </div>
        </div>
      )}

      {tab === "relax" && (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {relaxResources.map((resource) => (
            <div key={resource.title} className="bg-white rounded-xl border border-gray-200 p-5 hover:shadow-lg hover:shadow-gray-100 transition-all hover:-translate-y-0.5 group cursor-pointer">
              <div className="flex items-start gap-4">
                <div className={`w-14 h-14 rounded-2xl bg-gradient-to-br ${resource.color} flex items-center justify-center shrink-0 group-hover:scale-110 transition-transform`}>
                  <resource.icon className="w-7 h-7 text-white" />
                </div>
                <div className="flex-1">
                  <h3 className="font-semibold text-gray-900">{resource.title}</h3>
                  <div className="flex items-center gap-2 mt-1">
                    <span className="text-xs px-2 py-0.5 bg-gray-100 text-gray-600 rounded-full">{resource.type}</span>
                    <span className="text-xs text-gray-500">{resource.duration}</span>
                  </div>
                </div>
                <button className="w-10 h-10 rounded-full bg-indigo-50 flex items-center justify-center text-indigo-600 hover:bg-indigo-100 transition-colors shrink-0">
                  <Play className="w-5 h-5 ml-0.5" />
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
