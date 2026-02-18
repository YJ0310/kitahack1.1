import { useState } from "react";
import {
  Sparkles, Clock, CheckCircle2, XCircle, AlertTriangle,
  ArrowRight, Brain, Zap, Coffee,
  CalendarCheck, ListTodo, BarChart3, Target
} from "lucide-react";

const pendingDecisions = [
  {
    id: 1,
    title: "Should I attend Database lecture tomorrow?",
    context: "The topic is Normalization (3NF). I've already read the chapter.",
    aiRecommendation: "attend",
    aiReasoning: "While you've read the chapter, Dr. Mas Idayu typically gives practical examples not in the textbook. Plus, attendance affects 10% of your grade. The quiz next week covers this topic.",
    urgency: "medium",
    deadline: "Tomorrow, 2:00 PM",
    category: "Academic",
  },
  {
    id: 2,
    title: "Join the IoT Hackathon team or focus on assignments?",
    context: "Ahmad from Engineering invited me. 3 assignments due next week.",
    aiRecommendation: "balance",
    aiReasoning: "The hackathon is a great networking opportunity, but you have 3 assignments due. Suggestion: Accept the invitation but negotiate a lighter role. Complete Assignment 1 (easiest) tonight, leaving 5 days for the other 2.",
    urgency: "high",
    deadline: "Registration closes Friday",
    category: "Opportunity",
  },
  {
    id: 3,
    title: "Switch from Java to Python for the ML project?",
    context: "Team is split. Java is more familiar but Python has better ML libraries.",
    aiRecommendation: "switch",
    aiReasoning: "For an ML project, Python is strongly recommended. Libraries like scikit-learn, TensorFlow, and pandas will save 60%+ development time. Your Python fundamentals are solid enough. The learning curve will also benefit your future courses.",
    urgency: "medium",
    deadline: "Team meeting Wednesday",
    category: "Technical",
  },
];

const timeBlocks = [
  { time: "8:00 AM", task: "Morning Routine", type: "personal", duration: 1 },
  { time: "9:00 AM", task: "Data Structures Lecture", type: "class", duration: 2 },
  { time: "11:00 AM", task: "Assignment 1 - Database", type: "assignment", duration: 1.5 },
  { time: "12:30 PM", task: "Lunch Break", type: "break", duration: 1 },
  { time: "1:30 PM", task: "Study: Graph Algorithms", type: "study", duration: 2 },
  { time: "3:30 PM", task: "ML Study Group Meeting", type: "social", duration: 1.5 },
  { time: "5:00 PM", task: "Exercise / Free Time", type: "personal", duration: 1 },
  { time: "6:00 PM", task: "Dinner", type: "break", duration: 1 },
  { time: "7:00 PM", task: "Assignment 2 - Software Eng", type: "assignment", duration: 2 },
  { time: "9:00 PM", task: "Wellness Check-in & Wind Down", type: "personal", duration: 1 },
];

const typeColors: Record<string, string> = {
  class: "bg-indigo-100 text-indigo-700 border-indigo-200",
  assignment: "bg-amber-100 text-amber-700 border-amber-200",
  study: "bg-violet-100 text-violet-700 border-violet-200",
  social: "bg-emerald-100 text-emerald-700 border-emerald-200",
  personal: "bg-blue-100 text-blue-700 border-blue-200",
  break: "bg-gray-100 text-gray-600 border-gray-200",
};

const typeDotColors: Record<string, string> = {
  class: "bg-indigo-500",
  assignment: "bg-amber-500",
  study: "bg-violet-500",
  social: "bg-emerald-500",
  personal: "bg-blue-500",
  break: "bg-gray-400",
};

export function DecisionPage() {
  const [tab, setTab] = useState<"decisions" | "schedule" | "priorities">("decisions");
  const [expandedDecision, setExpandedDecision] = useState<number | null>(null);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Decision Helper</h1>
          <p className="text-gray-500 mt-1">AI-powered decisions and time management for student life.</p>
        </div>
        <div className="flex items-center gap-2 px-3 py-1.5 bg-indigo-50 rounded-lg border border-indigo-100">
          <Brain className="w-4 h-4 text-indigo-600" />
          <span className="text-sm font-medium text-indigo-700">Gemini Decision Engine</span>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex gap-1 bg-gray-100 rounded-xl p-1 w-fit">
        {([
          { id: "decisions" as const, label: "Decisions", icon: Sparkles },
          { id: "schedule" as const, label: "Smart Schedule", icon: CalendarCheck },
          { id: "priorities" as const, label: "Priorities", icon: Target },
        ]).map((t) => (
          <button
            key={t.id}
            onClick={() => setTab(t.id)}
            className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition-all ${
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

      {tab === "decisions" && (
        <div className="space-y-4">
          {/* New Decision */}
          <div className="bg-white rounded-xl border border-gray-200 p-5">
            <h3 className="font-semibold text-gray-900 mb-3 flex items-center gap-2">
              <Zap className="w-5 h-5 text-amber-500" />
              Need help deciding?
            </h3>
            <div className="flex gap-3">
              <input
                type="text"
                placeholder='Try: "Should I take 5 courses or 4 next semester?"'
                className="flex-1 px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-sm outline-none focus:border-indigo-300 focus:ring-2 focus:ring-indigo-100 transition-all"
              />
              <button className="px-5 py-2.5 bg-indigo-600 text-white text-sm font-medium rounded-xl hover:bg-indigo-700 transition-colors flex items-center gap-2">
                <Sparkles className="w-4 h-4" />
                Analyze
              </button>
            </div>
          </div>

          {/* Pending Decisions */}
          <div className="space-y-4">
            <h2 className="font-semibold text-gray-900 flex items-center gap-2">
              <ListTodo className="w-5 h-5 text-gray-400" />
              Pending Decisions
              <span className="text-xs bg-amber-100 text-amber-700 px-2 py-0.5 rounded-full">{pendingDecisions.length}</span>
            </h2>

            {pendingDecisions.map((decision) => (
              <div key={decision.id} className="bg-white rounded-xl border border-gray-200 overflow-hidden hover:shadow-md transition-all">
                <button
                  onClick={() => setExpandedDecision(expandedDecision === decision.id ? null : decision.id)}
                  className="w-full p-5 text-left"
                >
                  <div className="flex items-start justify-between gap-3">
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-1">
                        <span className={`text-xs px-2 py-0.5 rounded-full ${
                          decision.urgency === "high" ? "bg-red-50 text-red-600" :
                          decision.urgency === "medium" ? "bg-amber-50 text-amber-600" :
                          "bg-gray-100 text-gray-500"
                        }`}>{decision.urgency} priority</span>
                        <span className="text-xs px-2 py-0.5 bg-indigo-50 text-indigo-600 rounded-full">{decision.category}</span>
                      </div>
                      <h3 className="font-semibold text-gray-900">{decision.title}</h3>
                      <p className="text-sm text-gray-500 mt-1">{decision.context}</p>
                    </div>
                    <div className="flex items-center gap-1 text-xs text-gray-400 shrink-0">
                      <Clock className="w-3.5 h-3.5" />
                      {decision.deadline}
                    </div>
                  </div>
                </button>

                {expandedDecision === decision.id && (
                  <div className="px-5 pb-5 space-y-4">
                    <div className="bg-gradient-to-r from-indigo-50 to-violet-50 rounded-xl p-4 border border-indigo-100">
                      <div className="flex items-center gap-2 mb-2">
                        <Sparkles className="w-4 h-4 text-indigo-600" />
                        <span className="text-sm font-semibold text-indigo-900">AI Recommendation</span>
                        <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${
                          decision.aiRecommendation === "attend" ? "bg-emerald-100 text-emerald-700" :
                          decision.aiRecommendation === "switch" ? "bg-blue-100 text-blue-700" :
                          "bg-amber-100 text-amber-700"
                        }`}>
                          {decision.aiRecommendation === "attend" ? "✅ Attend" :
                           decision.aiRecommendation === "switch" ? "🔄 Switch" :
                           "⚖️ Balance Both"}
                        </span>
                      </div>
                      <p className="text-sm text-indigo-800 leading-relaxed">{decision.aiReasoning}</p>
                    </div>
                    <div className="flex items-center gap-2">
                      <button className="flex-1 px-4 py-2.5 bg-emerald-600 text-white text-sm font-medium rounded-xl hover:bg-emerald-700 transition-colors flex items-center justify-center gap-1.5">
                        <CheckCircle2 className="w-4 h-4" />
                        Accept
                      </button>
                      <button className="flex-1 px-4 py-2.5 bg-gray-100 text-gray-700 text-sm font-medium rounded-xl hover:bg-gray-200 transition-colors flex items-center justify-center gap-1.5">
                        <XCircle className="w-4 h-4" />
                        Dismiss
                      </button>
                      <button className="px-4 py-2.5 border border-gray-200 text-gray-600 text-sm rounded-xl hover:bg-gray-50 transition-colors flex items-center justify-center gap-1.5">
                        <ArrowRight className="w-4 h-4" />
                        More Options
                      </button>
                    </div>
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>
      )}

      {tab === "schedule" && (
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2">
            <div className="bg-white rounded-xl border border-gray-200 overflow-hidden">
              <div className="px-5 py-4 border-b border-gray-100 flex items-center justify-between">
                <h2 className="font-semibold text-gray-900">AI-Optimized Daily Schedule</h2>
                <span className="text-xs bg-indigo-50 text-indigo-600 px-2 py-1 rounded-full">Today</span>
              </div>
              <div className="p-4 space-y-2">
                {timeBlocks.map((block, i) => (
                  <div key={i} className="flex items-center gap-3 group">
                    <div className="w-16 text-xs text-gray-400 font-mono text-right shrink-0">{block.time}</div>
                    <div className={`w-2.5 h-2.5 rounded-full ${typeDotColors[block.type]} shrink-0`} />
                    <div className={`flex-1 px-4 py-3 rounded-xl border text-sm font-medium ${typeColors[block.type]} group-hover:shadow-sm transition-all`}>
                      <div className="flex items-center justify-between">
                        <span>{block.task}</span>
                        <span className="text-xs opacity-70">{block.duration}h</span>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* Schedule Insights */}
          <div className="space-y-4">
            <div className="bg-gradient-to-br from-indigo-50 to-violet-50 rounded-xl border border-indigo-100 p-5">
              <h3 className="font-semibold text-indigo-900 mb-3 flex items-center gap-2">
                <Brain className="w-5 h-5 text-indigo-600" />
                AI Schedule Insights
              </h3>
              <div className="space-y-3">
                {[
                  { text: "Your most productive hours are 9-11 AM. Heavy tasks are scheduled accordingly.", icon: "⚡" },
                  { text: "Break inserted after 2h study blocks to prevent burnout.", icon: "☕" },
                  { text: "Social activity placed at 3:30 PM for optimal energy.", icon: "🤝" },
                ].map((insight, i) => (
                  <div key={i} className="flex items-start gap-2 text-sm text-indigo-800">
                    <span className="shrink-0">{insight.icon}</span>
                    <span>{insight.text}</span>
                  </div>
                ))}
              </div>
            </div>

            <div className="bg-white rounded-xl border border-gray-200 p-5">
              <h3 className="font-semibold text-gray-900 mb-3">Time Distribution</h3>
              <div className="space-y-3">
                {[
                  { label: "Classes", hours: 2, color: "bg-indigo-500", total: 10 },
                  { label: "Assignments", hours: 3.5, color: "bg-amber-500", total: 10 },
                  { label: "Self Study", hours: 2, color: "bg-violet-500", total: 10 },
                  { label: "Social", hours: 1.5, color: "bg-emerald-500", total: 10 },
                  { label: "Personal", hours: 3, color: "bg-blue-500", total: 10 },
                ].map((item) => (
                  <div key={item.label}>
                    <div className="flex items-center justify-between text-sm mb-1">
                      <span className="text-gray-600 flex items-center gap-2">
                        <div className={`w-2.5 h-2.5 rounded-full ${item.color}`} />
                        {item.label}
                      </span>
                      <span className="font-medium text-gray-700">{item.hours}h</span>
                    </div>
                    <div className="w-full bg-gray-100 rounded-full h-1.5">
                      <div className={`h-1.5 rounded-full ${item.color}`} style={{ width: `${(item.hours / item.total) * 100}%` }} />
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      )}

      {tab === "priorities" && (
        <div className="space-y-4">
          <div className="bg-gradient-to-r from-amber-50 to-orange-50 rounded-xl border border-amber-100 p-5">
            <div className="flex items-start gap-3">
              <AlertTriangle className="w-6 h-6 text-amber-600 shrink-0" />
              <div>
                <h3 className="font-semibold text-amber-900">Priority Matrix</h3>
                <p className="text-sm text-amber-700/80 mt-1">AI-analyzed task priorities based on deadlines, weight, and your academic goals.</p>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {/* Urgent & Important */}
            <div className="bg-white rounded-xl border-2 border-red-200 p-5">
              <h3 className="font-semibold text-red-700 mb-3 flex items-center gap-2 text-sm uppercase tracking-wider">
                🔴 Urgent & Important
              </h3>
              <div className="space-y-2">
                {[
                  { task: "Database Assignment - Normalization", due: "Tomorrow", weight: "15%" },
                  { task: "Study for DSA Quiz", due: "Thursday", weight: "10%" },
                ].map((item, i) => (
                  <div key={i} className="p-3 bg-red-50 rounded-lg">
                    <div className="font-medium text-sm text-gray-900">{item.task}</div>
                    <div className="flex items-center gap-3 mt-1 text-xs text-gray-500">
                      <span className="flex items-center gap-1"><Clock className="w-3 h-3" /> {item.due}</span>
                      <span className="flex items-center gap-1"><BarChart3 className="w-3 h-3" /> {item.weight}</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Important, Not Urgent */}
            <div className="bg-white rounded-xl border-2 border-blue-200 p-5">
              <h3 className="font-semibold text-blue-700 mb-3 flex items-center gap-2 text-sm uppercase tracking-wider">
                🔵 Important, Not Urgent
              </h3>
              <div className="space-y-2">
                {[
                  { task: "Software Eng Group Project Plan", due: "Next Week", weight: "25%" },
                  { task: "Review ML prerequisites", due: "Before Next Sem", weight: "—" },
                ].map((item, i) => (
                  <div key={i} className="p-3 bg-blue-50 rounded-lg">
                    <div className="font-medium text-sm text-gray-900">{item.task}</div>
                    <div className="flex items-center gap-3 mt-1 text-xs text-gray-500">
                      <span className="flex items-center gap-1"><Clock className="w-3 h-3" /> {item.due}</span>
                      <span className="flex items-center gap-1"><BarChart3 className="w-3 h-3" /> {item.weight}</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Urgent, Not Important */}
            <div className="bg-white rounded-xl border-2 border-amber-200 p-5">
              <h3 className="font-semibold text-amber-700 mb-3 flex items-center gap-2 text-sm uppercase tracking-wider">
                🟡 Urgent, Not Important
              </h3>
              <div className="space-y-2">
                {[
                  { task: "Reply to hackathon team invitation", due: "Friday", weight: "—" },
                  { task: "Submit study circle availability", due: "Wednesday", weight: "—" },
                ].map((item, i) => (
                  <div key={i} className="p-3 bg-amber-50 rounded-lg">
                    <div className="font-medium text-sm text-gray-900">{item.task}</div>
                    <div className="flex items-center gap-3 mt-1 text-xs text-gray-500">
                      <span className="flex items-center gap-1"><Clock className="w-3 h-3" /> {item.due}</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Not Urgent, Not Important */}
            <div className="bg-white rounded-xl border-2 border-gray-200 p-5">
              <h3 className="font-semibold text-gray-600 mb-3 flex items-center gap-2 text-sm uppercase tracking-wider">
                ⚪ Can Wait
              </h3>
              <div className="space-y-2">
                {[
                  { task: "Organize notes folder", due: "Whenever", weight: "—" },
                  { task: "Update LinkedIn profile", due: "Whenever", weight: "—" },
                ].map((item, i) => (
                  <div key={i} className="p-3 bg-gray-50 rounded-lg">
                    <div className="font-medium text-sm text-gray-900">{item.task}</div>
                    <div className="flex items-center gap-3 mt-1 text-xs text-gray-500">
                      <span className="flex items-center gap-1"><Coffee className="w-3 h-3" /> {item.due}</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
