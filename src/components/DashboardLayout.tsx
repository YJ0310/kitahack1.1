import { type ReactNode, useState } from "react";
import { useRouter } from "../App";
import {
  GraduationCap, LayoutDashboard, Users, BookOpen, HeartPulse,
  Sparkles, User, LogOut, Bell, Search, Menu, X, ChevronDown
} from "lucide-react";

const navItems = [
  { id: "dashboard" as const, label: "Dashboard", icon: LayoutDashboard },
  { id: "network" as const, label: "Network", icon: Users },
  { id: "courses" as const, label: "AI Courses", icon: BookOpen },
  { id: "wellness" as const, label: "Wellness", icon: HeartPulse },
  { id: "decision" as const, label: "Decisions", icon: Sparkles },
];

export function DashboardLayout({ children }: { children: ReactNode }) {
  const { page, navigate, user } = useRouter();
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [profileOpen, setProfileOpen] = useState(false);

  return (
    <div className="min-h-screen bg-gray-50/80">
      {/* Mobile overlay */}
      {sidebarOpen && (
        <div className="fixed inset-0 z-40 bg-black/30 backdrop-blur-sm lg:hidden" onClick={() => setSidebarOpen(false)} />
      )}

      {/* Sidebar */}
      <aside className={`fixed top-0 left-0 z-50 h-full w-64 bg-white border-r border-gray-200 transform transition-transform duration-200 ease-in-out ${sidebarOpen ? 'translate-x-0' : '-translate-x-full'} lg:translate-x-0`}>
        <div className="flex flex-col h-full">
          {/* Logo */}
          <div className="h-16 px-5 flex items-center justify-between border-b border-gray-100">
            <div className="flex items-center gap-2.5">
              <div className="w-9 h-9 rounded-xl bg-gradient-to-br from-indigo-600 to-violet-600 flex items-center justify-center shadow-lg shadow-indigo-200">
                <GraduationCap className="w-5 h-5 text-white" />
              </div>
              <span className="text-lg font-bold bg-gradient-to-r from-indigo-700 to-violet-600 bg-clip-text text-transparent">UniHub</span>
            </div>
            <button onClick={() => setSidebarOpen(false)} className="lg:hidden p-1 hover:bg-gray-100 rounded-lg">
              <X className="w-5 h-5 text-gray-500" />
            </button>
          </div>

          {/* User card */}
          <div className="px-4 py-4">
            <div className="flex items-center gap-3 p-3 bg-gradient-to-br from-indigo-50 to-violet-50 rounded-xl border border-indigo-100">
              <div className="w-10 h-10 rounded-full bg-gradient-to-br from-indigo-500 to-violet-500 flex items-center justify-center text-white font-bold text-sm shrink-0">
                JQ
              </div>
              <div className="min-w-0">
                <div className="font-semibold text-sm text-gray-900 truncate">{user.name}</div>
                <div className="text-xs text-indigo-600 truncate">{user.faculty.replace("Faculty of ", "")}</div>
              </div>
            </div>
          </div>

          {/* Nav */}
          <nav className="flex-1 px-3 space-y-1">
            <div className="px-3 py-2 text-xs font-semibold text-gray-400 uppercase tracking-wider">Main Menu</div>
            {navItems.map((item) => {
              const isActive = page === item.id;
              return (
                <button
                  key={item.id}
                  onClick={() => { navigate(item.id); setSidebarOpen(false); }}
                  className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition-all ${
                    isActive
                      ? "bg-gradient-to-r from-indigo-600 to-violet-600 text-white shadow-md shadow-indigo-200"
                      : "text-gray-600 hover:bg-gray-100 hover:text-gray-900"
                  }`}
                >
                  <item.icon className={`w-5 h-5 ${isActive ? "text-white" : "text-gray-400"}`} />
                  {item.label}
                </button>
              );
            })}
          </nav>

          {/* Bottom */}
          <div className="p-4 border-t border-gray-100 space-y-1">
            <button
              onClick={() => { navigate("profile"); setSidebarOpen(false); }}
              className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition-all ${
                page === "profile"
                  ? "bg-gradient-to-r from-indigo-600 to-violet-600 text-white shadow-md shadow-indigo-200"
                  : "text-gray-600 hover:bg-gray-100"
              }`}
            >
              <User className={`w-5 h-5 ${page === "profile" ? "text-white" : "text-gray-400"}`} />
              Profile
            </button>
            <button
              onClick={() => navigate("landing")}
              className="w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium text-red-500 hover:bg-red-50 transition-all"
            >
              <LogOut className="w-5 h-5" />
              Sign Out
            </button>
          </div>
        </div>
      </aside>

      {/* Main Content */}
      <div className="lg:ml-64">
        {/* Top Bar */}
        <header className="sticky top-0 z-30 h-16 bg-white/80 backdrop-blur-xl border-b border-gray-100 px-4 md:px-6 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <button onClick={() => setSidebarOpen(true)} className="lg:hidden p-2 hover:bg-gray-100 rounded-lg">
              <Menu className="w-5 h-5 text-gray-600" />
            </button>
            <div className="hidden sm:flex items-center gap-2 px-4 py-2 bg-gray-100 rounded-xl w-72">
              <Search className="w-4 h-4 text-gray-400" />
              <input
                type="text"
                placeholder="Search students, courses..."
                className="bg-transparent text-sm text-gray-700 placeholder-gray-400 outline-none w-full"
              />
            </div>
          </div>
          <div className="flex items-center gap-3">
            <button className="relative p-2 hover:bg-gray-100 rounded-xl transition-colors">
              <Bell className="w-5 h-5 text-gray-500" />
              <div className="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full" />
            </button>
            <div className="relative">
              <button
                onClick={() => setProfileOpen(!profileOpen)}
                className="flex items-center gap-2 p-1.5 hover:bg-gray-100 rounded-xl transition-colors"
              >
                <div className="w-8 h-8 rounded-full bg-gradient-to-br from-indigo-500 to-violet-500 flex items-center justify-center text-white font-bold text-xs">
                  JQ
                </div>
                <ChevronDown className="w-4 h-4 text-gray-400 hidden sm:block" />
              </button>
              {profileOpen && (
                <>
                  <div className="fixed inset-0 z-40" onClick={() => setProfileOpen(false)} />
                  <div className="absolute right-0 mt-2 w-56 bg-white rounded-xl shadow-xl border border-gray-200 py-2 z-50">
                    <div className="px-4 py-3 border-b border-gray-100">
                      <div className="font-semibold text-sm text-gray-900">{user.name}</div>
                      <div className="text-xs text-gray-500">{user.email}</div>
                    </div>
                    <button
                      onClick={() => { navigate("profile"); setProfileOpen(false); }}
                      className="w-full px-4 py-2 text-left text-sm text-gray-700 hover:bg-gray-50 flex items-center gap-2"
                    >
                      <User className="w-4 h-4" /> View Profile
                    </button>
                    <button
                      onClick={() => { navigate("landing"); setProfileOpen(false); }}
                      className="w-full px-4 py-2 text-left text-sm text-red-600 hover:bg-red-50 flex items-center gap-2"
                    >
                      <LogOut className="w-4 h-4" /> Sign Out
                    </button>
                  </div>
                </>
              )}
            </div>
          </div>
        </header>

        {/* Page Content */}
        <main className="p-4 md:p-6 lg:p-8">
          {children}
        </main>
      </div>
    </div>
  );
}
