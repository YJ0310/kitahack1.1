import { useState } from "react";
import {
  BookOpen, Sparkles, Clock, Star, Download, ChevronRight,
  FileText, Monitor, AlertTriangle, CheckCircle2, Lightbulb,
  GraduationCap, BarChart3, Calendar, Brain
} from "lucide-react";

const currentCourses = [
  {
    code: "WIA2004",
    name: "Data Structures & Algorithms",
    lecturer: "Dr. Rosni Abdullah",
    progress: 65,
    nextTopic: "Graph Algorithms - BFS & DFS",
    prepItems: ["Review adjacency list/matrix", "Install Visualgo bookmark"],
    difficulty: "Medium",
    color: "from-blue-500 to-indigo-600",
  },
  {
    code: "WIA2005",
    name: "Database Management Systems",
    lecturer: "Dr. Mas Idayu",
    progress: 50,
    nextTopic: "Normalization - 3NF & BCNF",
    prepItems: ["Complete ER diagram exercise", "Read Chapter 7"],
    difficulty: "Medium",
    color: "from-violet-500 to-purple-600",
  },
  {
    code: "WIA2006",
    name: "Software Engineering",
    lecturer: "Dr. Nazean Jomhari",
    progress: 40,
    nextTopic: "Agile Development & Scrum",
    prepItems: ["Read Scrum Guide", "Watch Agile intro video"],
    difficulty: "Easy",
    color: "from-emerald-500 to-teal-600",
  },
  {
    code: "WIA2007",
    name: "Computer Networks",
    lecturer: "Dr. Ang Tan Fong",
    progress: 55,
    nextTopic: "Transport Layer - TCP/UDP",
    prepItems: ["Install Wireshark", "Review OSI model layers"],
    difficulty: "Hard",
    color: "from-amber-500 to-orange-600",
  },
];

const recommendedCourses = [
  { name: "Machine Learning", code: "WIA3001", reason: "Matches your Python skills and Data Science interest", match: 95, faculty: "FSKTM" },
  { name: "Human-Computer Interaction", code: "WIA3003", reason: "Complements your Software Engineering background", match: 88, faculty: "FSKTM" },
  { name: "Cloud Computing", code: "WIA3005", reason: "High demand skill, builds on your network knowledge", match: 85, faculty: "FSKTM" },
];

export function CoursesPage() {
  const [tab, setTab] = useState<"current" | "recommend" | "prep">("current");
  const [selectedCourse, setSelectedCourse] = useState<string | null>(null);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">AI Course Assistant</h1>
          <p className="text-gray-500 mt-1">Smart course management powered by Google Gemini.</p>
        </div>
        <div className="flex items-center gap-2 px-3 py-1.5 bg-indigo-50 rounded-lg border border-indigo-100">
          <Sparkles className="w-4 h-4 text-indigo-600" />
          <span className="text-sm font-medium text-indigo-700">Gemini AI Active</span>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex gap-1 bg-gray-100 rounded-xl p-1 w-fit">
        {([
          { id: "current" as const, label: "My Courses", icon: BookOpen },
          { id: "recommend" as const, label: "AI Recommendations", icon: Brain },
          { id: "prep" as const, label: "Prep Guide", icon: Lightbulb },
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

      {tab === "current" && (
        <>
          {/* Semester Overview */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
            <div className="bg-white rounded-xl border border-gray-200 p-5">
              <div className="flex items-center gap-3 mb-2">
                <div className="w-10 h-10 bg-indigo-50 rounded-xl flex items-center justify-center">
                  <BookOpen className="w-5 h-5 text-indigo-600" />
                </div>
                <div>
                  <div className="text-2xl font-bold text-gray-900">6</div>
                  <div className="text-sm text-gray-500">Enrolled Courses</div>
                </div>
              </div>
            </div>
            <div className="bg-white rounded-xl border border-gray-200 p-5">
              <div className="flex items-center gap-3 mb-2">
                <div className="w-10 h-10 bg-amber-50 rounded-xl flex items-center justify-center">
                  <AlertTriangle className="w-5 h-5 text-amber-600" />
                </div>
                <div>
                  <div className="text-2xl font-bold text-gray-900">3</div>
                  <div className="text-sm text-gray-500">Assignments Due</div>
                </div>
              </div>
            </div>
            <div className="bg-white rounded-xl border border-gray-200 p-5">
              <div className="flex items-center gap-3 mb-2">
                <div className="w-10 h-10 bg-emerald-50 rounded-xl flex items-center justify-center">
                  <BarChart3 className="w-5 h-5 text-emerald-600" />
                </div>
                <div>
                  <div className="text-2xl font-bold text-gray-900">52%</div>
                  <div className="text-sm text-gray-500">Avg Progress</div>
                </div>
              </div>
            </div>
          </div>

          {/* Course Cards */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
            {currentCourses.map((course) => (
              <div
                key={course.code}
                className={`bg-white rounded-xl border border-gray-200 overflow-hidden hover:shadow-lg hover:shadow-gray-100 transition-all cursor-pointer ${selectedCourse === course.code ? 'ring-2 ring-indigo-500' : ''}`}
                onClick={() => setSelectedCourse(selectedCourse === course.code ? null : course.code)}
              >
                <div className={`h-1.5 bg-gradient-to-r ${course.color}`} />
                <div className="p-5">
                  <div className="flex items-start justify-between mb-3">
                    <div>
                      <div className="text-xs font-mono text-gray-400 mb-0.5">{course.code}</div>
                      <h3 className="font-semibold text-gray-900">{course.name}</h3>
                      <p className="text-xs text-gray-500 mt-0.5">{course.lecturer}</p>
                    </div>
                    <span className={`text-xs px-2 py-1 rounded-full ${
                      course.difficulty === "Easy" ? "bg-emerald-50 text-emerald-600" :
                      course.difficulty === "Medium" ? "bg-amber-50 text-amber-600" :
                      "bg-red-50 text-red-600"
                    }`}>{course.difficulty}</span>
                  </div>

                  {/* Progress bar */}
                  <div className="mb-4">
                    <div className="flex items-center justify-between text-xs mb-1">
                      <span className="text-gray-500">Progress</span>
                      <span className="font-medium text-gray-700">{course.progress}%</span>
                    </div>
                    <div className="w-full bg-gray-100 rounded-full h-2">
                      <div className={`h-2 rounded-full bg-gradient-to-r ${course.color}`} style={{ width: `${course.progress}%` }} />
                    </div>
                  </div>

                  {/* Next topic */}
                  <div className="bg-gray-50 rounded-lg p-3 mb-3">
                    <div className="text-xs font-medium text-gray-500 mb-1 flex items-center gap-1">
                      <Calendar className="w-3 h-3" />
                      Next Topic
                    </div>
                    <p className="text-sm font-medium text-gray-900">{course.nextTopic}</p>
                  </div>

                  {selectedCourse === course.code && (
                    <div className="space-y-3 animate-in">
                      <div className="border-t border-gray-100 pt-3">
                        <div className="text-xs font-medium text-indigo-600 mb-2 flex items-center gap-1">
                          <Sparkles className="w-3 h-3" />
                          AI Pre-Study Recommendations
                        </div>
                        {course.prepItems.map((item, i) => (
                          <div key={i} className="flex items-center gap-2 text-sm text-gray-600 mb-1.5">
                            <CheckCircle2 className="w-4 h-4 text-indigo-400 shrink-0" />
                            {item}
                          </div>
                        ))}
                      </div>
                      <div className="flex gap-2">
                        <button className="flex-1 px-3 py-2 bg-indigo-600 text-white text-sm rounded-lg hover:bg-indigo-700 transition-colors flex items-center justify-center gap-1.5">
                          <FileText className="w-4 h-4" />
                          View Syllabus
                        </button>
                        <button className="px-3 py-2 border border-gray-200 text-gray-600 text-sm rounded-lg hover:bg-gray-50 transition-colors flex items-center justify-center gap-1.5">
                          <Download className="w-4 h-4" />
                        </button>
                      </div>
                    </div>
                  )}
                </div>
              </div>
            ))}
          </div>
        </>
      )}

      {tab === "recommend" && (
        <div className="space-y-4">
          {/* AI Analysis Card */}
          <div className="bg-gradient-to-br from-indigo-50 to-violet-50 rounded-xl border border-indigo-100 p-6">
            <div className="flex items-start gap-3">
              <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-indigo-500 to-violet-500 flex items-center justify-center shrink-0">
                <Brain className="w-6 h-6 text-white" />
              </div>
              <div>
                <h3 className="font-semibold text-indigo-900 mb-1">Gemini Course Analysis</h3>
                <p className="text-sm text-indigo-700/80 leading-relaxed">
                  Based on your current courses, skills, career interests, and GPA trends, here are personalized course recommendations for next semester. These selections optimize for both your academic growth and career readiness.
                </p>
              </div>
            </div>
          </div>

          {/* Recommended Courses */}
          {recommendedCourses.map((course, i) => (
            <div key={course.code} className="bg-white rounded-xl border border-gray-200 p-5 hover:shadow-lg hover:shadow-gray-100 transition-all">
              <div className="flex items-start gap-4">
                <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-indigo-100 to-violet-100 flex items-center justify-center text-indigo-600 font-bold text-lg shrink-0">
                  {i + 1}
                </div>
                <div className="flex-1">
                  <div className="flex items-start justify-between gap-3">
                    <div>
                      <div className="text-xs font-mono text-gray-400">{course.code}</div>
                      <h3 className="font-semibold text-gray-900 text-lg">{course.name}</h3>
                      <p className="text-xs text-gray-500 mt-0.5">{course.faculty}</p>
                    </div>
                    <div className="text-right shrink-0">
                      <div className="text-2xl font-bold text-indigo-600">{course.match}%</div>
                      <div className="text-xs text-gray-400">AI match</div>
                    </div>
                  </div>
                  <div className="mt-3 flex items-start gap-2 bg-indigo-50 rounded-lg p-3">
                    <Sparkles className="w-4 h-4 text-indigo-600 mt-0.5 shrink-0" />
                    <p className="text-sm text-indigo-700">{course.reason}</p>
                  </div>
                  <div className="mt-3 flex gap-2">
                    <button className="px-4 py-2 bg-indigo-600 text-white text-sm font-medium rounded-lg hover:bg-indigo-700 transition-colors flex items-center gap-1.5">
                      <Star className="w-4 h-4" /> Add to Wishlist
                    </button>
                    <button className="px-4 py-2 border border-gray-200 text-gray-600 text-sm rounded-lg hover:bg-gray-50 transition-colors flex items-center gap-1.5">
                      View Details <ChevronRight className="w-4 h-4" />
                    </button>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {tab === "prep" && (
        <div className="space-y-4">
          <div className="bg-gradient-to-r from-amber-50 to-orange-50 rounded-xl border border-amber-100 p-5">
            <div className="flex items-start gap-3">
              <div className="w-10 h-10 rounded-xl bg-amber-100 flex items-center justify-center shrink-0">
                <Lightbulb className="w-5 h-5 text-amber-600" />
              </div>
              <div>
                <h3 className="font-semibold text-amber-900">Next Semester Prep Guide</h3>
                <p className="text-sm text-amber-700/80 mt-1">AI-generated preparation guide based on Spectrum/Moodle course outlines for the upcoming semester.</p>
              </div>
            </div>
          </div>

          {[
            {
              title: "Machine Learning Fundamentals",
              software: ["Python 3.11+", "Jupyter Notebook", "scikit-learn", "TensorFlow"],
              prereqs: ["Linear Algebra", "Statistics", "Python Programming"],
              tips: "Start with Andrew Ng's ML course on Coursera for a head start. Focus on understanding gradient descent and neural network basics.",
              weeks: "14 weeks",
            },
            {
              title: "Cloud Computing",
              software: ["Google Cloud CLI", "Docker", "Kubernetes", "Terraform"],
              prereqs: ["Computer Networks", "Operating Systems", "Basic Linux"],
              tips: "Set up a free-tier GCP account and complete the Qwiklabs introductory quests before semester starts.",
              weeks: "14 weeks",
            },
            {
              title: "Human-Computer Interaction",
              software: ["Figma", "Adobe XD", "Miro Board"],
              prereqs: ["Software Engineering", "Basic Design Principles"],
              tips: "Start a design journal. Analyze 3-5 apps you use daily and document what makes them user-friendly.",
              weeks: "13 weeks",
            },
          ].map((prep) => (
            <div key={prep.title} className="bg-white rounded-xl border border-gray-200 p-5">
              <h3 className="font-semibold text-gray-900 text-lg mb-4">{prep.title}</h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                <div>
                  <div className="text-xs font-medium text-gray-500 mb-2 flex items-center gap-1">
                    <Monitor className="w-3.5 h-3.5" />
                    Required Software
                  </div>
                  <div className="flex flex-wrap gap-1.5">
                    {prep.software.map((s) => (
                      <span key={s} className="text-xs px-2.5 py-1 bg-blue-50 text-blue-700 rounded-full font-medium">{s}</span>
                    ))}
                  </div>
                </div>
                <div>
                  <div className="text-xs font-medium text-gray-500 mb-2 flex items-center gap-1">
                    <GraduationCap className="w-3.5 h-3.5" />
                    Prerequisites
                  </div>
                  <div className="flex flex-wrap gap-1.5">
                    {prep.prereqs.map((p) => (
                      <span key={p} className="text-xs px-2.5 py-1 bg-violet-50 text-violet-700 rounded-full font-medium">{p}</span>
                    ))}
                  </div>
                </div>
              </div>
              <div className="bg-gray-50 rounded-lg p-3 flex items-start gap-2">
                <Sparkles className="w-4 h-4 text-indigo-600 mt-0.5 shrink-0" />
                <div>
                  <div className="text-xs font-medium text-indigo-600 mb-0.5">AI Study Tip</div>
                  <p className="text-sm text-gray-700">{prep.tips}</p>
                </div>
              </div>
              <div className="flex items-center gap-2 mt-3 text-xs text-gray-500">
                <Clock className="w-3.5 h-3.5" />
                Duration: {prep.weeks}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
