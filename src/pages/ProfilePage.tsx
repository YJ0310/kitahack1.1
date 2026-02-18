import { useRouter } from "../App";
import {
  GraduationCap, Mail, MapPin, Calendar, Code, Users,
  BookOpen, Star, Award, Edit3, ExternalLink, Github,
  Linkedin, Globe, HeartPulse, Trophy
} from "lucide-react";

const skills = [
  { name: "Python", level: 90 },
  { name: "Java", level: 75 },
  { name: "Flutter", level: 40 },
  { name: "Firebase", level: 50 },
  { name: "Machine Learning", level: 60 },
  { name: "Data Analysis", level: 70 },
];

const achievements = [
  { title: "Early Adopter", desc: "Among the first 100 users", icon: "🌟", date: "Jan 2025" },
  { title: "Social Butterfly", desc: "Connected with 40+ students", icon: "🦋", date: "Feb 2025" },
  { title: "Streak Master", desc: "7-day wellness check-in streak", icon: "🔥", date: "Feb 2025" },
  { title: "Helper", desc: "Answered 10+ questions in circles", icon: "🤝", date: "Feb 2025" },
];

export function ProfilePage() {
  const { user } = useRouter();

  return (
    <div className="space-y-6 max-w-5xl mx-auto">
      {/* Profile Header */}
      <div className="bg-white rounded-2xl border border-gray-200 overflow-hidden">
        {/* Cover */}
        <div className="h-40 bg-gradient-to-r from-indigo-600 via-violet-600 to-purple-600 relative">
          <div className="absolute inset-0 opacity-20" style={{
            backgroundImage: 'radial-gradient(circle at 25% 50%, white 1px, transparent 1px), radial-gradient(circle at 75% 50%, white 1px, transparent 1px)',
            backgroundSize: '40px 40px'
          }} />
        </div>

        {/* Profile info */}
        <div className="px-6 pb-6 relative">
          <div className="flex flex-col sm:flex-row sm:items-end gap-4 -mt-12">
            <div className="w-24 h-24 rounded-2xl bg-gradient-to-br from-indigo-500 to-violet-500 flex items-center justify-center text-white font-bold text-3xl border-4 border-white shadow-xl">
              JQ
            </div>
            <div className="flex-1 sm:pb-1">
              <h1 className="text-2xl font-bold text-gray-900">{user.name}</h1>
              <p className="text-gray-500">{user.faculty}</p>
            </div>
            <button className="px-4 py-2 bg-indigo-600 text-white text-sm font-medium rounded-xl hover:bg-indigo-700 transition-colors flex items-center gap-2 self-start sm:self-auto">
              <Edit3 className="w-4 h-4" />
              Edit Profile
            </button>
          </div>

          {/* Info grid */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mt-6">
            {[
              { icon: Mail, label: "Email", value: user.email },
              { icon: GraduationCap, label: "Year", value: user.year },
              { icon: MapPin, label: "Campus", value: "University of Malaya" },
              { icon: Calendar, label: "Joined", value: "January 2025" },
            ].map((item) => (
              <div key={item.label} className="flex items-center gap-2.5">
                <div className="w-9 h-9 rounded-lg bg-gray-100 flex items-center justify-center shrink-0">
                  <item.icon className="w-4 h-4 text-gray-500" />
                </div>
                <div className="min-w-0">
                  <div className="text-xs text-gray-400">{item.label}</div>
                  <div className="text-sm font-medium text-gray-900 truncate">{item.value}</div>
                </div>
              </div>
            ))}
          </div>

          {/* Social Links */}
          <div className="flex items-center gap-2 mt-4">
            {[
              { icon: Github, label: "GitHub" },
              { icon: Linkedin, label: "LinkedIn" },
              { icon: Globe, label: "Portfolio" },
            ].map((link) => (
              <button key={link.label} className="p-2 bg-gray-100 rounded-lg hover:bg-indigo-50 hover:text-indigo-600 transition-colors text-gray-500">
                <link.icon className="w-4 h-4" />
              </button>
            ))}
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left Column */}
        <div className="lg:col-span-2 space-y-6">
          {/* About */}
          <div className="bg-white rounded-xl border border-gray-200 p-6">
            <h2 className="font-semibold text-gray-900 mb-3 flex items-center gap-2">
              <Star className="w-5 h-5 text-indigo-600" />
              About
            </h2>
            <p className="text-sm text-gray-600 leading-relaxed">
              Year 3 Computer Science student at University of Malaya, passionate about AI/ML and cross-disciplinary collaboration.
              Currently exploring the intersection of technology and education. Project Manager for the UniHub hackathon project.
              Looking to connect with students from diverse backgrounds for research and innovation.
            </p>
          </div>

          {/* Skills */}
          <div className="bg-white rounded-xl border border-gray-200 p-6">
            <h2 className="font-semibold text-gray-900 mb-4 flex items-center gap-2">
              <Code className="w-5 h-5 text-indigo-600" />
              Skills & Proficiency
            </h2>
            <div className="space-y-4">
              {skills.map((skill) => (
                <div key={skill.name}>
                  <div className="flex items-center justify-between text-sm mb-1.5">
                    <span className="font-medium text-gray-700">{skill.name}</span>
                    <span className="text-gray-400">{skill.level}%</span>
                  </div>
                  <div className="w-full bg-gray-100 rounded-full h-2">
                    <div
                      className="h-2 rounded-full bg-gradient-to-r from-indigo-500 to-violet-500 transition-all"
                      style={{ width: `${skill.level}%` }}
                    />
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Interests */}
          <div className="bg-white rounded-xl border border-gray-200 p-6">
            <h2 className="font-semibold text-gray-900 mb-3 flex items-center gap-2">
              <BookOpen className="w-5 h-5 text-indigo-600" />
              Academic Interests
            </h2>
            <div className="flex flex-wrap gap-2">
              {["Artificial Intelligence", "Machine Learning", "EdTech", "Cross-disciplinary Research",
                "Cloud Computing", "Data Science", "UX Design", "Project Management"].map((interest) => (
                <span key={interest} className="px-3 py-1.5 bg-indigo-50 text-indigo-700 rounded-full text-sm font-medium">
                  {interest}
                </span>
              ))}
            </div>
          </div>
        </div>

        {/* Right Column */}
        <div className="space-y-6">
          {/* Stats */}
          <div className="bg-white rounded-xl border border-gray-200 p-5">
            <h2 className="font-semibold text-gray-900 mb-4 text-sm">Quick Stats</h2>
            <div className="grid grid-cols-2 gap-3">
              {[
                { label: "Connections", value: "47", icon: Users, color: "text-blue-600", bg: "bg-blue-50" },
                { label: "Courses", value: "6", icon: BookOpen, color: "text-violet-600", bg: "bg-violet-50" },
                { label: "Wellness", value: "85%", icon: HeartPulse, color: "text-emerald-600", bg: "bg-emerald-50" },
                { label: "Circles", value: "4", icon: Globe, color: "text-amber-600", bg: "bg-amber-50" },
              ].map((stat) => (
                <div key={stat.label} className="text-center p-3 bg-gray-50 rounded-xl">
                  <div className={`w-10 h-10 ${stat.bg} rounded-xl flex items-center justify-center mx-auto mb-2`}>
                    <stat.icon className={`w-5 h-5 ${stat.color}`} />
                  </div>
                  <div className="text-lg font-bold text-gray-900">{stat.value}</div>
                  <div className="text-xs text-gray-500">{stat.label}</div>
                </div>
              ))}
            </div>
          </div>

          {/* Achievements */}
          <div className="bg-white rounded-xl border border-gray-200 p-5">
            <h2 className="font-semibold text-gray-900 mb-4 flex items-center gap-2">
              <Trophy className="w-5 h-5 text-amber-500" />
              Achievements
            </h2>
            <div className="space-y-3">
              {achievements.map((achievement) => (
                <div key={achievement.title} className="flex items-center gap-3 p-3 bg-gray-50 rounded-xl">
                  <span className="text-2xl">{achievement.icon}</span>
                  <div className="flex-1 min-w-0">
                    <div className="font-medium text-sm text-gray-900">{achievement.title}</div>
                    <div className="text-xs text-gray-500">{achievement.desc}</div>
                  </div>
                  <span className="text-xs text-gray-400 shrink-0">{achievement.date}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Circles */}
          <div className="bg-white rounded-xl border border-gray-200 p-5">
            <h2 className="font-semibold text-gray-900 mb-4 text-sm flex items-center justify-between">
              My Circles
              <button className="text-indigo-600 hover:text-indigo-700 flex items-center gap-1 font-medium">
                View All <ExternalLink className="w-3.5 h-3.5" />
              </button>
            </h2>
            <div className="space-y-2">
              {[
                { name: "ML Study Group", members: 34, color: "from-blue-500 to-indigo-600" },
                { name: "Hackathon Warriors", members: 52, color: "from-violet-500 to-purple-600" },
                { name: "UI/UX Design", members: 28, color: "from-pink-500 to-rose-600" },
                { name: "Campus Musicians", members: 41, color: "from-cyan-500 to-blue-600" },
              ].map((circle) => (
                <div key={circle.name} className="flex items-center gap-3 p-2 hover:bg-gray-50 rounded-lg transition-colors">
                  <div className={`w-8 h-8 rounded-lg bg-gradient-to-br ${circle.color} flex items-center justify-center`}>
                    <Award className="w-4 h-4 text-white" />
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="text-sm font-medium text-gray-900 truncate">{circle.name}</div>
                    <div className="text-xs text-gray-500">{circle.members} members</div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
