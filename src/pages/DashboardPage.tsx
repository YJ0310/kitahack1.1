import { useRouter } from "../App";
import {
  Users, BookOpen, HeartPulse, Sparkles, TrendingUp, Calendar,
  ArrowUpRight, Clock, CheckCircle2, MessageCircle, Flame, Target
} from "lucide-react";

export function DashboardPage() {
  const { navigate, user } = useRouter();

  const stats = [
    { label: "Connections", value: "47", change: "+5 this week", icon: Users, color: "from-blue-500 to-indigo-600", bg: "bg-blue-50", iconColor: "text-blue-600" },
    { label: "Active Courses", value: "6", change: "2 assignments due", icon: BookOpen, color: "from-violet-500 to-purple-600", bg: "bg-violet-50", iconColor: "text-violet-600" },
    { label: "Wellness Score", value: "85%", change: "+12% from last month", icon: HeartPulse, color: "from-emerald-500 to-teal-600", bg: "bg-emerald-50", iconColor: "text-emerald-600" },
    { label: "Decisions Made", value: "23", change: "3 pending", icon: Sparkles, color: "from-amber-500 to-orange-600", bg: "bg-amber-50", iconColor: "text-amber-600" },
  ];

  const recentActivity = [
    { icon: Users, text: "New connection request from Ahmad R. (Engineering)", time: "2 min ago", color: "text-blue-600", bg: "bg-blue-50" },
    { icon: CheckCircle2, text: "Assignment: Data Structures Quiz 3 - Due Tomorrow", time: "1 hour ago", color: "text-emerald-600", bg: "bg-emerald-50" },
    { icon: MessageCircle, text: "New message in 'ML Study Group' circle", time: "3 hours ago", color: "text-violet-600", bg: "bg-violet-50" },
    { icon: HeartPulse, text: "Weekly wellness check-in reminder", time: "5 hours ago", color: "text-rose-600", bg: "bg-rose-50" },
    { icon: Sparkles, text: "AI suggested: Pre-read Chapter 5 for tomorrow's lecture", time: "Yesterday", color: "text-amber-600", bg: "bg-amber-50" },
  ];

  const upcomingCourses = [
    { name: "Data Structures & Algorithms", time: "9:00 AM", room: "DK3", status: "today", color: "bg-indigo-500" },
    { name: "Database Management Systems", time: "2:00 PM", room: "DK7", status: "today", color: "bg-violet-500" },
    { name: "Software Engineering", time: "10:00 AM", room: "DK1", status: "tomorrow", color: "bg-emerald-500" },
  ];

  const suggestedConnections = [
    { name: "Wei Ting C.", faculty: "Medicine", skills: ["Research", "Data Analysis"], match: 92 },
    { name: "Sarah L.", faculty: "Linguistics", skills: ["NLP", "Writing"], match: 88 },
    { name: "Raj K.", faculty: "Engineering", skills: ["IoT", "Hardware"], match: 85 },
  ];

  return (
    <div className="space-y-6">
      {/* Welcome Banner */}
      <div className="bg-gradient-to-r from-indigo-600 via-violet-600 to-purple-600 rounded-2xl p-6 md:p-8 text-white relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-64 bg-white/5 rounded-full -translate-y-1/2 translate-x-1/2" />
        <div className="absolute bottom-0 left-1/3 w-48 h-48 bg-white/5 rounded-full translate-y-1/2" />
        <div className="relative">
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
            <div>
              <h1 className="text-2xl md:text-3xl font-bold mb-2">
                Good morning, {user.name}! 👋
              </h1>
              <p className="text-indigo-100 max-w-lg">
                You have 2 classes today and 3 pending connection requests. Your wellness score is looking great!
              </p>
            </div>
            <div className="flex items-center gap-3">
              <div className="px-4 py-2 bg-white/15 backdrop-blur rounded-xl border border-white/20 text-sm font-medium flex items-center gap-2">
                <Flame className="w-4 h-4 text-amber-300" />
                7-day streak!
              </div>
              <div className="px-4 py-2 bg-white/15 backdrop-blur rounded-xl border border-white/20 text-sm font-medium flex items-center gap-2">
                <Target className="w-4 h-4 text-emerald-300" />
                {user.year}
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {stats.map((stat) => (
          <button
            key={stat.label}
            onClick={() => {
              if (stat.label === "Connections") navigate("network");
              else if (stat.label === "Active Courses") navigate("courses");
              else if (stat.label === "Wellness Score") navigate("wellness");
              else navigate("decision");
            }}
            className="bg-white rounded-xl p-5 border border-gray-200 hover:shadow-lg hover:shadow-gray-100 transition-all hover:-translate-y-0.5 text-left group"
          >
            <div className="flex items-center justify-between mb-3">
              <div className={`w-10 h-10 ${stat.bg} rounded-xl flex items-center justify-center`}>
                <stat.icon className={`w-5 h-5 ${stat.iconColor}`} />
              </div>
              <ArrowUpRight className="w-4 h-4 text-gray-300 group-hover:text-indigo-500 transition-colors" />
            </div>
            <div className={`text-2xl font-bold bg-gradient-to-r ${stat.color} bg-clip-text text-transparent`}>
              {stat.value}
            </div>
            <div className="text-sm text-gray-500 mt-0.5">{stat.label}</div>
            <div className="flex items-center gap-1 mt-2">
              <TrendingUp className="w-3 h-3 text-emerald-500" />
              <span className="text-xs text-emerald-600">{stat.change}</span>
            </div>
          </button>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Recent Activity */}
        <div className="lg:col-span-2 bg-white rounded-xl border border-gray-200 overflow-hidden">
          <div className="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
            <h2 className="font-semibold text-gray-900">Recent Activity</h2>
            <button className="text-sm text-indigo-600 hover:text-indigo-700 font-medium">View All</button>
          </div>
          <div className="divide-y divide-gray-50">
            {recentActivity.map((item, i) => (
              <div key={i} className="px-6 py-3.5 flex items-center gap-4 hover:bg-gray-50/50 transition-colors">
                <div className={`w-9 h-9 rounded-lg ${item.bg} flex items-center justify-center shrink-0`}>
                  <item.icon className={`w-4 h-4 ${item.color}`} />
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm text-gray-700 truncate">{item.text}</p>
                </div>
                <span className="text-xs text-gray-400 shrink-0">{item.time}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Today's Schedule */}
        <div className="bg-white rounded-xl border border-gray-200 overflow-hidden">
          <div className="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
            <h2 className="font-semibold text-gray-900">Schedule</h2>
            <div className="flex items-center gap-1 text-xs text-gray-500">
              <Calendar className="w-3.5 h-3.5" />
              Today
            </div>
          </div>
          <div className="p-4 space-y-3">
            {upcomingCourses.map((course, i) => (
              <div key={i} className="flex items-center gap-3 p-3 bg-gray-50 rounded-xl">
                <div className={`w-1.5 h-10 ${course.color} rounded-full`} />
                <div className="flex-1 min-w-0">
                  <div className="text-sm font-medium text-gray-900 truncate">{course.name}</div>
                  <div className="flex items-center gap-2 text-xs text-gray-500 mt-0.5">
                    <Clock className="w-3 h-3" />
                    {course.time} · {course.room}
                  </div>
                </div>
                <span className={`text-xs px-2 py-0.5 rounded-full ${
                  course.status === "today" ? "bg-indigo-50 text-indigo-600" : "bg-gray-100 text-gray-500"
                }`}>{course.status}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Suggested Connections + AI Insights */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Suggested Connections */}
        <div className="bg-white rounded-xl border border-gray-200 overflow-hidden">
          <div className="px-6 py-4 border-b border-gray-100 flex items-center justify-between">
            <h2 className="font-semibold text-gray-900">Suggested Connections</h2>
            <button onClick={() => navigate("network")} className="text-sm text-indigo-600 hover:text-indigo-700 font-medium">See All</button>
          </div>
          <div className="p-4 space-y-3">
            {suggestedConnections.map((person, i) => (
              <div key={i} className="flex items-center gap-3 p-3 bg-gray-50 rounded-xl">
                <div className="w-10 h-10 rounded-full bg-gradient-to-br from-indigo-400 to-violet-500 flex items-center justify-center text-white font-semibold text-sm shrink-0">
                  {person.name[0]}
                </div>
                <div className="flex-1 min-w-0">
                  <div className="text-sm font-medium text-gray-900">{person.name}</div>
                  <div className="text-xs text-gray-500">{person.faculty}</div>
                  <div className="flex gap-1.5 mt-1">
                    {person.skills.map((s) => (
                      <span key={s} className="text-xs px-2 py-0.5 bg-indigo-50 text-indigo-600 rounded-full">{s}</span>
                    ))}
                  </div>
                </div>
                <div className="text-right shrink-0">
                  <div className="text-sm font-bold text-indigo-600">{person.match}%</div>
                  <div className="text-xs text-gray-400">match</div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* AI Insights */}
        <div className="bg-gradient-to-br from-indigo-50 to-violet-50 rounded-xl border border-indigo-100 overflow-hidden">
          <div className="px-6 py-4 border-b border-indigo-100 flex items-center gap-2">
            <Sparkles className="w-5 h-5 text-indigo-600" />
            <h2 className="font-semibold text-indigo-900">AI Insights</h2>
            <span className="text-xs bg-indigo-100 text-indigo-700 px-2 py-0.5 rounded-full">Gemini</span>
          </div>
          <div className="p-4 space-y-3">
            {[
              { title: "📚 Pre-study Alert", desc: "Install Python 3.11 and Jupyter Notebook before next week's ML class. Tutorial will use scikit-learn.", priority: "high" },
              { title: "🤝 Team Opportunity", desc: "3 Engineering students are looking for a CS partner for their IoT project. Your Python skills are a perfect match!", priority: "medium" },
              { title: "💡 Study Tip", desc: "Based on your past quiz scores, spend 30 more minutes on graph algorithms before Thursday's test.", priority: "medium" },
              { title: "🧘 Wellness Reminder", desc: "You've been studying for 4 hours straight. Consider a 15-min break. Here are some breathing exercises.", priority: "low" },
            ].map((insight, i) => (
              <div key={i} className="bg-white rounded-xl p-4 border border-indigo-100/50 hover:shadow-md transition-shadow">
                <div className="flex items-start justify-between gap-2">
                  <h3 className="text-sm font-semibold text-gray-900">{insight.title}</h3>
                  <span className={`text-xs px-2 py-0.5 rounded-full shrink-0 ${
                    insight.priority === "high" ? "bg-red-50 text-red-600" :
                    insight.priority === "medium" ? "bg-amber-50 text-amber-600" :
                    "bg-gray-100 text-gray-500"
                  }`}>{insight.priority}</span>
                </div>
                <p className="text-xs text-gray-600 mt-1 leading-relaxed">{insight.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
