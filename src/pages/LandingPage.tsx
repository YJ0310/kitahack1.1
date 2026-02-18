import { useRouter } from "../App";
import {
  GraduationCap, Users, Brain, HeartPulse, Sparkles, ArrowRight,
  BookOpen, Globe, Shield, Zap, ChevronRight, Star, MessageCircle
} from "lucide-react";

export function LandingPage() {
  const { navigate } = useRouter();

  return (
    <div className="min-h-screen bg-white">
      {/* Navbar */}
      <nav className="fixed top-0 left-0 right-0 z-50 bg-white/80 backdrop-blur-xl border-b border-gray-100">
        <div className="max-w-7xl mx-auto px-6 h-16 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="w-9 h-9 rounded-xl bg-gradient-to-br from-indigo-600 to-violet-600 flex items-center justify-center shadow-lg shadow-indigo-200">
              <GraduationCap className="w-5 h-5 text-white" />
            </div>
            <span className="text-xl font-bold bg-gradient-to-r from-indigo-700 to-violet-600 bg-clip-text text-transparent">
              UniHub
            </span>
          </div>
          <div className="hidden md:flex items-center gap-8">
            <a href="#features" className="text-sm text-gray-600 hover:text-indigo-600 transition-colors">Features</a>
            <a href="#how" className="text-sm text-gray-600 hover:text-indigo-600 transition-colors">How It Works</a>
            <a href="#team" className="text-sm text-gray-600 hover:text-indigo-600 transition-colors">Team</a>
          </div>
          <div className="flex items-center gap-3">
            <button
              onClick={() => navigate("login")}
              className="px-4 py-2 text-sm font-medium text-indigo-600 hover:bg-indigo-50 rounded-lg transition-colors"
            >
              Log In
            </button>
            <button
              onClick={() => navigate("login")}
              className="px-4 py-2 text-sm font-medium text-white bg-gradient-to-r from-indigo-600 to-violet-600 rounded-lg hover:shadow-lg hover:shadow-indigo-200 transition-all hover:-translate-y-0.5"
            >
              Get Started
            </button>
          </div>
        </div>
      </nav>

      {/* Hero */}
      <section className="pt-32 pb-20 px-6 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-br from-indigo-50/80 via-white to-violet-50/80" />
        <div className="absolute top-20 left-10 w-72 h-72 bg-indigo-200/30 rounded-full blur-3xl" />
        <div className="absolute bottom-10 right-10 w-96 h-96 bg-violet-200/30 rounded-full blur-3xl" />
        <div className="absolute top-40 right-1/4 w-48 h-48 bg-cyan-200/20 rounded-full blur-3xl" />

        <div className="max-w-7xl mx-auto relative">
          <div className="max-w-3xl mx-auto text-center">
            <div className="inline-flex items-center gap-2 px-4 py-1.5 bg-indigo-50 border border-indigo-100 rounded-full mb-6">
              <Sparkles className="w-4 h-4 text-indigo-600" />
              <span className="text-sm font-medium text-indigo-700">Powered by Google Gemini AI</span>
            </div>
            <h1 className="text-5xl md:text-7xl font-extrabold tracking-tight mb-6">
              <span className="text-gray-900">Campus Life,</span>
              <br />
              <span className="bg-gradient-to-r from-indigo-600 via-violet-600 to-purple-600 bg-clip-text text-transparent">
                Connected.
              </span>
            </h1>
            <p className="text-lg md:text-xl text-gray-600 mb-8 max-w-2xl mx-auto leading-relaxed">
              The all-in-one platform for university students. Connect across faculties,
              get AI-powered course guidance, and take care of your well-being — all in one place.
            </p>
            <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
              <button
                onClick={() => navigate("login")}
                className="group w-full sm:w-auto px-8 py-3.5 text-base font-semibold text-white bg-gradient-to-r from-indigo-600 to-violet-600 rounded-xl hover:shadow-xl hover:shadow-indigo-200 transition-all hover:-translate-y-0.5 flex items-center justify-center gap-2"
              >
                Start Your Journey
                <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
              </button>
              <button className="w-full sm:w-auto px-8 py-3.5 text-base font-semibold text-gray-700 bg-white border border-gray-200 rounded-xl hover:border-indigo-300 hover:bg-indigo-50/50 transition-all flex items-center justify-center gap-2">
                Watch Demo
                <ChevronRight className="w-4 h-4" />
              </button>
            </div>
          </div>

          {/* Dashboard preview */}
          <div className="mt-16 relative">
            <div className="absolute -inset-4 bg-gradient-to-r from-indigo-500/20 via-violet-500/20 to-purple-500/20 rounded-3xl blur-2xl" />
            <div className="relative bg-white rounded-2xl shadow-2xl shadow-gray-200/60 border border-gray-200 overflow-hidden">
              <div className="bg-gray-100 px-4 py-3 flex items-center gap-2">
                <div className="flex gap-1.5">
                  <div className="w-3 h-3 rounded-full bg-red-400" />
                  <div className="w-3 h-3 rounded-full bg-yellow-400" />
                  <div className="w-3 h-3 rounded-full bg-green-400" />
                </div>
                <div className="flex-1 flex justify-center">
                  <div className="px-4 py-1 bg-white rounded-md text-xs text-gray-500 border border-gray-200">
                    unihub.app/dashboard
                  </div>
                </div>
              </div>
              <div className="p-6 bg-gradient-to-br from-slate-50 to-indigo-50/30">
                <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                  {/* Mini sidebar */}
                  <div className="hidden md:block bg-white rounded-xl p-4 shadow-sm border border-gray-100">
                    <div className="flex items-center gap-3 mb-6">
                      <div className="w-10 h-10 rounded-full bg-gradient-to-br from-indigo-500 to-violet-500 flex items-center justify-center text-white font-bold text-sm">JQ</div>
                      <div>
                        <div className="font-semibold text-sm text-gray-900">Jia Qian</div>
                        <div className="text-xs text-gray-500">CS & IT</div>
                      </div>
                    </div>
                    <div className="space-y-1">
                      {["Dashboard", "Network", "Courses", "Wellness"].map((item, i) => (
                        <div key={item} className={`px-3 py-2 rounded-lg text-sm ${i === 0 ? 'bg-indigo-50 text-indigo-700 font-medium' : 'text-gray-600'}`}>
                          {item}
                        </div>
                      ))}
                    </div>
                  </div>
                  {/* Main content preview */}
                  <div className="md:col-span-3 space-y-4">
                    <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                      {[
                        { label: "Connections", value: "47", color: "from-indigo-500 to-blue-500" },
                        { label: "Courses", value: "6", color: "from-violet-500 to-purple-500" },
                        { label: "Wellness Score", value: "85%", color: "from-emerald-500 to-teal-500" },
                      ].map((stat) => (
                        <div key={stat.label} className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
                          <div className="text-xs text-gray-500 mb-1">{stat.label}</div>
                          <div className={`text-2xl font-bold bg-gradient-to-r ${stat.color} bg-clip-text text-transparent`}>
                            {stat.value}
                          </div>
                        </div>
                      ))}
                    </div>
                    <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
                      <div className="text-sm font-semibold text-gray-900 mb-3">AI Course Recommendations</div>
                      <div className="space-y-2">
                        {["Data Structures & Algorithms", "Machine Learning Fundamentals", "UI/UX Design Principles"].map((c) => (
                          <div key={c} className="flex items-center gap-3 p-2 bg-gray-50 rounded-lg">
                            <div className="w-2 h-2 rounded-full bg-indigo-500" />
                            <span className="text-sm text-gray-700">{c}</span>
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* SDG Banner */}
      <section className="py-12 bg-gradient-to-r from-indigo-600 via-violet-600 to-purple-600">
        <div className="max-w-7xl mx-auto px-6">
          <div className="flex flex-col md:flex-row items-center justify-between gap-6">
            <div className="text-center md:text-left">
              <div className="text-indigo-200 text-sm font-medium mb-1">Supporting UN Sustainable Development Goals</div>
              <div className="text-white text-xl font-bold">SDG 3: Good Health & Well-being · SDG 4: Quality Education</div>
            </div>
            <div className="flex items-center gap-4">
              <div className="w-16 h-16 bg-white/15 rounded-xl flex items-center justify-center backdrop-blur-sm border border-white/20">
                <HeartPulse className="w-8 h-8 text-white" />
              </div>
              <div className="w-16 h-16 bg-white/15 rounded-xl flex items-center justify-center backdrop-blur-sm border border-white/20">
                <BookOpen className="w-8 h-8 text-white" />
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Features */}
      <section id="features" className="py-24 px-6 bg-white">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <div className="inline-flex items-center gap-2 px-3 py-1 bg-indigo-50 rounded-full mb-4">
              <Zap className="w-4 h-4 text-indigo-600" />
              <span className="text-sm font-medium text-indigo-700">Core Features</span>
            </div>
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Everything you need for campus life</h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              From cross-faculty networking to AI-powered study tools — UniHub has you covered.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {[
              {
                icon: Users,
                title: "Cross-Disciplinary Network",
                desc: "Connect with students across all faculties. Find teammates with complementary skills for projects, research, and competitions.",
                color: "from-blue-500 to-indigo-600",
                bg: "bg-blue-50",
                features: ["AI-powered skill matching", "Faculty-cross teams", "Academic interest circles", "Talent pool for recruiters"],
              },
              {
                icon: Brain,
                title: "AI Course Assistant",
                desc: "Get personalized course recommendations, prep guides, and syllabus analysis powered by Google Gemini.",
                color: "from-violet-500 to-purple-600",
                bg: "bg-violet-50",
                features: ["Syllabus auto-analysis", "Pre-study guides", "Software prep alerts", "Smart scheduling"],
              },
              {
                icon: HeartPulse,
                title: "Wellness & Mental Health",
                desc: "Daily mood tracking, anonymous sharing, AI counseling support, and curated relaxation resources.",
                color: "from-emerald-500 to-teal-600",
                bg: "bg-emerald-50",
                features: ["Mood check-in tracker", "Anonymous tree hole", "AI wellness chat", "Relaxation resources"],
              },
              {
                icon: Sparkles,
                title: "Decision Helper",
                desc: "AI-assisted decision making for academic and daily choices. Should you skip that lecture? Let AI help you decide.",
                color: "from-amber-500 to-orange-600",
                bg: "bg-amber-50",
                features: ["Smart scheduling", "Priority analysis", "Moodle integration", "Time management"],
              },
            ].map((feature) => (
              <div key={feature.title} className="group relative bg-white rounded-2xl border border-gray-200 p-8 hover:shadow-xl hover:shadow-gray-100 transition-all hover:-translate-y-1 overflow-hidden">
                <div className="absolute top-0 right-0 w-32 h-32 bg-gradient-to-br opacity-5 rounded-bl-full" style={{}} />
                <div className={`w-14 h-14 ${feature.bg} rounded-2xl flex items-center justify-center mb-5`}>
                  <feature.icon className={`w-7 h-7 bg-gradient-to-r ${feature.color} bg-clip-text`} style={{ color: feature.color.includes("blue") ? "#4f46e5" : feature.color.includes("violet") ? "#7c3aed" : feature.color.includes("emerald") ? "#059669" : "#d97706" }} />
                </div>
                <h3 className="text-xl font-bold text-gray-900 mb-2">{feature.title}</h3>
                <p className="text-gray-600 mb-5 leading-relaxed">{feature.desc}</p>
                <ul className="space-y-2">
                  {feature.features.map((f) => (
                    <li key={f} className="flex items-center gap-2 text-sm text-gray-600">
                      <div className={`w-1.5 h-1.5 rounded-full bg-gradient-to-r ${feature.color}`} />
                      {f}
                    </li>
                  ))}
                </ul>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* How it works */}
      <section id="how" className="py-24 px-6 bg-gradient-to-b from-gray-50 to-white">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Get started in 3 steps</h2>
            <p className="text-gray-600 max-w-xl mx-auto">Join the platform in seconds and unlock your full campus potential.</p>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {[
              { step: "01", title: "Sign in with Google", desc: "One-click login with your university Google account. No extra passwords needed.", icon: Shield },
              { step: "02", title: "Set Up Your Profile", desc: "Add your faculty, skills, and interests. Our AI starts building your personalized experience.", icon: Globe },
              { step: "03", title: "Explore & Connect", desc: "Discover courses, find teammates, and access wellness resources tailored just for you.", icon: Sparkles },
            ].map((item) => (
              <div key={item.step} className="text-center">
                <div className="relative inline-flex items-center justify-center w-20 h-20 rounded-2xl bg-gradient-to-br from-indigo-600 to-violet-600 text-white mb-6 shadow-lg shadow-indigo-200">
                  <item.icon className="w-8 h-8" />
                  <div className="absolute -top-2 -right-2 w-8 h-8 bg-white rounded-lg shadow-md flex items-center justify-center text-xs font-bold text-indigo-600 border border-indigo-100">
                    {item.step}
                  </div>
                </div>
                <h3 className="text-lg font-bold text-gray-900 mb-2">{item.title}</h3>
                <p className="text-gray-600 leading-relaxed">{item.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Tech Stack */}
      <section className="py-20 px-6 bg-white">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-12">
            <h2 className="text-2xl font-bold text-gray-900 mb-2">Built with Cutting-Edge Technology</h2>
            <p className="text-gray-500">Powered by Google's ecosystem</p>
          </div>
          <div className="flex flex-wrap items-center justify-center gap-6">
            {[
              { name: "Google Gemini AI", emoji: "🤖" },
              { name: "Flutter", emoji: "📱" },
              { name: "Firebase", emoji: "🔥" },
              { name: "Google Cloud", emoji: "☁️" },
              { name: "Vertex AI", emoji: "🧠" },
            ].map((tech) => (
              <div key={tech.name} className="flex items-center gap-3 px-6 py-3 bg-gray-50 rounded-xl border border-gray-200 hover:border-indigo-300 hover:bg-indigo-50/50 transition-all">
                <span className="text-2xl">{tech.emoji}</span>
                <span className="font-medium text-gray-700">{tech.name}</span>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Team */}
      <section id="team" className="py-24 px-6 bg-gradient-to-b from-gray-50 to-white">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Meet the Team</h2>
            <p className="text-gray-600">Built with 💜 by UM students for UM students</p>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            {[
              { name: "Sek", role: "Tech Lead / Full Stack", desc: "Backend & frontend integration", color: "from-blue-500 to-indigo-600", initial: "S" },
              { name: "Jolin", role: "Developer (Full Stack)", desc: "Flutter & database development", color: "from-violet-500 to-purple-600", initial: "J" },
              { name: "Ruo Qian", role: "Developer", desc: "Coding & tech stack learning", color: "from-emerald-500 to-teal-600", initial: "R" },
              { name: "Jia Qian", role: "PM / Strategist", desc: "Planning, APIs & business model", color: "from-amber-500 to-orange-600", initial: "JQ" },
            ].map((member) => (
              <div key={member.name} className="bg-white rounded-2xl border border-gray-200 p-6 text-center hover:shadow-lg hover:shadow-gray-100 transition-all hover:-translate-y-1">
                <div className={`w-16 h-16 rounded-2xl bg-gradient-to-br ${member.color} flex items-center justify-center text-white font-bold text-xl mx-auto mb-4 shadow-lg`}>
                  {member.initial}
                </div>
                <h3 className="font-bold text-gray-900 text-lg">{member.name}</h3>
                <p className="text-sm font-medium text-indigo-600 mb-2">{member.role}</p>
                <p className="text-sm text-gray-500">{member.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Testimonials */}
      <section className="py-20 px-6 bg-white">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">What Students Say</h2>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {[
              { quote: "UniHub helped me find a CS student for my linguistics research project. Cross-faculty collaboration has never been easier!", name: "Sarah L.", faculty: "Faculty of Languages", stars: 5 },
              { quote: "The AI course assistant predicted exactly what software I'd need next semester. I was fully prepared on day one!", name: "Ahmad R.", faculty: "Faculty of Engineering", stars: 5 },
              { quote: "The mood tracking and wellness features helped me realize I needed to take breaks. My mental health has improved so much.", name: "Wei Ting C.", faculty: "Faculty of Medicine", stars: 5 },
            ].map((t) => (
              <div key={t.name} className="bg-gray-50 rounded-2xl p-6 border border-gray-100">
                <div className="flex gap-1 mb-3">
                  {Array.from({ length: t.stars }).map((_, i) => (
                    <Star key={i} className="w-4 h-4 fill-amber-400 text-amber-400" />
                  ))}
                </div>
                <p className="text-gray-700 mb-4 leading-relaxed italic">"{t.quote}"</p>
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-full bg-gradient-to-br from-indigo-400 to-violet-500 flex items-center justify-center text-white font-semibold text-sm">
                    {t.name[0]}
                  </div>
                  <div>
                    <div className="font-semibold text-gray-900 text-sm">{t.name}</div>
                    <div className="text-xs text-gray-500">{t.faculty}</div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="py-24 px-6 bg-gradient-to-br from-indigo-600 via-violet-600 to-purple-700 relative overflow-hidden">
        <div className="absolute top-0 left-1/4 w-96 h-96 bg-white/5 rounded-full blur-3xl" />
        <div className="absolute bottom-0 right-1/4 w-72 h-72 bg-white/5 rounded-full blur-3xl" />
        <div className="max-w-3xl mx-auto text-center relative">
          <MessageCircle className="w-12 h-12 text-white/80 mx-auto mb-6" />
          <h2 className="text-3xl md:text-4xl font-bold text-white mb-4">Ready to transform your campus experience?</h2>
          <p className="text-indigo-100 text-lg mb-8 max-w-xl mx-auto">
            Join thousands of UM students already using UniHub to connect, learn, and thrive.
          </p>
          <button
            onClick={() => navigate("login")}
            className="group px-8 py-4 bg-white text-indigo-700 font-semibold rounded-xl hover:shadow-2xl transition-all hover:-translate-y-1 inline-flex items-center gap-2"
          >
            Get Started for Free
            <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
          </button>
        </div>
      </section>

      {/* Footer */}
      <footer className="py-12 px-6 bg-gray-900 text-gray-400">
        <div className="max-w-7xl mx-auto">
          <div className="flex flex-col md:flex-row items-center justify-between gap-4">
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-indigo-500 to-violet-500 flex items-center justify-center">
                <GraduationCap className="w-4 h-4 text-white" />
              </div>
              <span className="font-bold text-white">UniHub</span>
            </div>
            <p className="text-sm">© 2025 UniHub. Built for Google Solution Challenge.</p>
            <div className="flex items-center gap-4 text-sm">
              <span>SDG 3 & 4</span>
              <span>·</span>
              <span>University of Malaya</span>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}
