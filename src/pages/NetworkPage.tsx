import { useState } from "react";
import {
  Search, Filter, Users, UserPlus, MessageCircle, Star,
  Briefcase, GraduationCap, Code, Palette, FlaskConical,
  Globe, BookOpen, Music, ChevronDown
} from "lucide-react";

const students = [
  { name: "Ahmad Razif", faculty: "Engineering", year: "Year 2", skills: ["IoT", "Arduino", "C++"], match: 95, bio: "Passionate about embedded systems and smart devices.", interests: ["Robotics", "AI"], avatar: "AR" },
  { name: "Sarah Lim", faculty: "Linguistics", year: "Year 3", skills: ["NLP", "Writing", "Research"], match: 91, bio: "Exploring the intersection of language and technology.", interests: ["Computational Linguistics", "Translation"], avatar: "SL" },
  { name: "Wei Ting Chong", faculty: "Medicine", year: "Year 4", skills: ["Data Analysis", "R", "SPSS"], match: 88, bio: "Med student interested in health tech and data science.", interests: ["Health Tech", "Biostatistics"], avatar: "WC" },
  { name: "Priya Nair", faculty: "Business", year: "Year 2", skills: ["Marketing", "Design", "Strategy"], match: 85, bio: "Business strategist with a design thinking mindset.", interests: ["Startups", "UX Design"], avatar: "PN" },
  { name: "Kai Jie Tan", faculty: "Computer Science", year: "Year 3", skills: ["Python", "ML", "Cloud"], match: 82, bio: "Building ML models and deploying them on the cloud.", interests: ["Deep Learning", "MLOps"], avatar: "KT" },
  { name: "Nurul Aisyah", faculty: "Education", year: "Year 2", skills: ["Pedagogy", "Content Creation", "EdTech"], match: 79, bio: "Future educator passionate about technology in learning.", interests: ["EdTech", "Gamification"], avatar: "NA" },
];

const circles = [
  { name: "Machine Learning Study Group", members: 34, faculty: "Cross-Faculty", icon: Code, color: "from-blue-500 to-indigo-600", posts: 156 },
  { name: "UI/UX Design Circle", members: 28, faculty: "Cross-Faculty", icon: Palette, color: "from-pink-500 to-rose-600", posts: 89 },
  { name: "Research Methods Workshop", members: 19, faculty: "Cross-Faculty", icon: FlaskConical, color: "from-emerald-500 to-teal-600", posts: 45 },
  { name: "Hackathon Warriors", members: 52, faculty: "Cross-Faculty", icon: Globe, color: "from-violet-500 to-purple-600", posts: 203 },
  { name: "Academic Writing Hub", members: 15, faculty: "Cross-Faculty", icon: BookOpen, color: "from-amber-500 to-orange-600", posts: 67 },
  { name: "Campus Musicians", members: 41, faculty: "Cross-Faculty", icon: Music, color: "from-cyan-500 to-blue-600", posts: 112 },
];

const faculties = ["All Faculties", "Computer Science", "Engineering", "Medicine", "Business", "Linguistics", "Education", "Science", "Law", "Arts"];

export function NetworkPage() {
  const [tab, setTab] = useState<"discover" | "circles" | "requests">("discover");
  const [selectedFaculty, setSelectedFaculty] = useState("All Faculties");
  const [searchQuery, setSearchQuery] = useState("");
  const [showFilters, setShowFilters] = useState(false);

  const filteredStudents = students.filter((s) => {
    const matchesFaculty = selectedFaculty === "All Faculties" || s.faculty === selectedFaculty;
    const matchesSearch = searchQuery === "" ||
      s.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      s.skills.some(sk => sk.toLowerCase().includes(searchQuery.toLowerCase()));
    return matchesFaculty && matchesSearch;
  });

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Cross-Disciplinary Network</h1>
          <p className="text-gray-500 mt-1">Discover students across faculties and build your academic network.</p>
        </div>
        <div className="flex items-center gap-2">
          <span className="px-3 py-1.5 bg-indigo-50 text-indigo-700 text-sm rounded-lg font-medium flex items-center gap-1.5">
            <Users className="w-4 h-4" />
            500+ Students
          </span>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex gap-1 bg-gray-100 rounded-xl p-1 w-fit">
        {([
          { id: "discover" as const, label: "Discover", icon: Search },
          { id: "circles" as const, label: "Circles", icon: Users },
          { id: "requests" as const, label: "Requests", icon: UserPlus, badge: 3 },
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
            {t.badge && (
              <span className="w-5 h-5 bg-red-500 text-white text-xs rounded-full flex items-center justify-center">
                {t.badge}
              </span>
            )}
          </button>
        ))}
      </div>

      {tab === "discover" && (
        <>
          {/* Search & Filter */}
          <div className="flex flex-col sm:flex-row gap-3">
            <div className="flex-1 flex items-center gap-2 px-4 py-2.5 bg-white border border-gray-200 rounded-xl">
              <Search className="w-4 h-4 text-gray-400" />
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search by name, skills, or interests..."
                className="bg-transparent text-sm text-gray-700 placeholder-gray-400 outline-none w-full"
              />
            </div>
            <button
              onClick={() => setShowFilters(!showFilters)}
              className="flex items-center gap-2 px-4 py-2.5 bg-white border border-gray-200 rounded-xl text-sm text-gray-600 hover:border-indigo-300 transition-colors"
            >
              <Filter className="w-4 h-4" />
              Filters
              <ChevronDown className={`w-4 h-4 transition-transform ${showFilters ? 'rotate-180' : ''}`} />
            </button>
          </div>

          {showFilters && (
            <div className="bg-white rounded-xl border border-gray-200 p-4">
              <div className="text-sm font-medium text-gray-700 mb-3">Faculty</div>
              <div className="flex flex-wrap gap-2">
                {faculties.map((f) => (
                  <button
                    key={f}
                    onClick={() => setSelectedFaculty(f)}
                    className={`px-3 py-1.5 rounded-lg text-sm transition-all ${
                      selectedFaculty === f
                        ? "bg-indigo-600 text-white"
                        : "bg-gray-100 text-gray-600 hover:bg-gray-200"
                    }`}
                  >
                    {f}
                  </button>
                ))}
              </div>
            </div>
          )}

          {/* AI Match Banner */}
          <div className="bg-gradient-to-r from-indigo-50 to-violet-50 rounded-xl p-4 border border-indigo-100 flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-indigo-100 flex items-center justify-center shrink-0">
              <Star className="w-5 h-5 text-indigo-600" />
            </div>
            <div>
              <p className="text-sm font-medium text-indigo-900">AI-Powered Matching</p>
              <p className="text-xs text-indigo-600">Match scores are calculated by Gemini AI based on complementary skills, shared interests, and collaboration potential.</p>
            </div>
          </div>

          {/* Student Cards */}
          <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
            {filteredStudents.map((student) => (
              <div key={student.name} className="bg-white rounded-xl border border-gray-200 p-5 hover:shadow-lg hover:shadow-gray-100 transition-all hover:-translate-y-0.5 group">
                <div className="flex items-start gap-3 mb-4">
                  <div className="w-12 h-12 rounded-full bg-gradient-to-br from-indigo-400 to-violet-500 flex items-center justify-center text-white font-bold shrink-0">
                    {student.avatar}
                  </div>
                  <div className="flex-1 min-w-0">
                    <h3 className="font-semibold text-gray-900">{student.name}</h3>
                    <div className="flex items-center gap-2 text-xs text-gray-500 mt-0.5">
                      <GraduationCap className="w-3 h-3" />
                      {student.faculty} · {student.year}
                    </div>
                  </div>
                  <div className="text-right">
                    <div className="text-lg font-bold text-indigo-600">{student.match}%</div>
                    <div className="text-xs text-gray-400">match</div>
                  </div>
                </div>
                <p className="text-sm text-gray-600 mb-3">{student.bio}</p>
                <div className="flex flex-wrap gap-1.5 mb-4">
                  {student.skills.map((s) => (
                    <span key={s} className="text-xs px-2 py-1 bg-indigo-50 text-indigo-600 rounded-full font-medium">{s}</span>
                  ))}
                </div>
                <div className="flex items-center gap-2">
                  <button className="flex-1 px-3 py-2 bg-indigo-600 text-white text-sm font-medium rounded-lg hover:bg-indigo-700 transition-colors flex items-center justify-center gap-1.5">
                    <UserPlus className="w-4 h-4" />
                    Connect
                  </button>
                  <button className="px-3 py-2 border border-gray-200 text-gray-600 text-sm rounded-lg hover:bg-gray-50 transition-colors flex items-center justify-center gap-1.5">
                    <MessageCircle className="w-4 h-4" />
                  </button>
                  <button className="px-3 py-2 border border-gray-200 text-gray-600 text-sm rounded-lg hover:bg-gray-50 transition-colors flex items-center justify-center gap-1.5">
                    <Briefcase className="w-4 h-4" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        </>
      )}

      {tab === "circles" && (
        <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
          {circles.map((circle) => (
            <div key={circle.name} className="bg-white rounded-xl border border-gray-200 p-5 hover:shadow-lg hover:shadow-gray-100 transition-all hover:-translate-y-0.5">
              <div className="flex items-start gap-3 mb-4">
                <div className={`w-12 h-12 rounded-xl bg-gradient-to-br ${circle.color} flex items-center justify-center`}>
                  <circle.icon className="w-6 h-6 text-white" />
                </div>
                <div className="flex-1">
                  <h3 className="font-semibold text-gray-900">{circle.name}</h3>
                  <p className="text-xs text-gray-500 mt-0.5">{circle.faculty}</p>
                </div>
              </div>
              <div className="flex items-center gap-4 mb-4">
                <div className="flex items-center gap-1.5 text-sm text-gray-600">
                  <Users className="w-4 h-4 text-gray-400" />
                  {circle.members} members
                </div>
                <div className="flex items-center gap-1.5 text-sm text-gray-600">
                  <MessageCircle className="w-4 h-4 text-gray-400" />
                  {circle.posts} posts
                </div>
              </div>
              <button className="w-full px-4 py-2 bg-indigo-50 text-indigo-700 font-medium text-sm rounded-lg hover:bg-indigo-100 transition-colors">
                Join Circle
              </button>
            </div>
          ))}
        </div>
      )}

      {tab === "requests" && (
        <div className="space-y-3">
          {[
            { name: "Li Wei Chen", faculty: "Physics", message: "Hi! I'm looking for a CS partner for my quantum computing research project.", avatar: "LC" },
            { name: "Aisha binti Yusof", faculty: "Architecture", message: "Would love to collaborate on a smart building design project!", avatar: "AY" },
            { name: "Marcus Tan", faculty: "Data Science", message: "Interested in joining your ML study group. I have experience with PyTorch.", avatar: "MT" },
          ].map((req) => (
            <div key={req.name} className="bg-white rounded-xl border border-gray-200 p-5 flex flex-col sm:flex-row sm:items-center gap-4">
              <div className="w-12 h-12 rounded-full bg-gradient-to-br from-indigo-400 to-violet-500 flex items-center justify-center text-white font-bold shrink-0">
                {req.avatar}
              </div>
              <div className="flex-1 min-w-0">
                <h3 className="font-semibold text-gray-900">{req.name}</h3>
                <p className="text-xs text-gray-500">{req.faculty}</p>
                <p className="text-sm text-gray-600 mt-1">{req.message}</p>
              </div>
              <div className="flex items-center gap-2 shrink-0">
                <button className="px-4 py-2 bg-indigo-600 text-white text-sm font-medium rounded-lg hover:bg-indigo-700 transition-colors">
                  Accept
                </button>
                <button className="px-4 py-2 border border-gray-200 text-gray-600 text-sm rounded-lg hover:bg-gray-50 transition-colors">
                  Decline
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
