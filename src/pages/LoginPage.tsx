import { useRouter } from "../App";
import { GraduationCap, ArrowLeft } from "lucide-react";

export function LoginPage() {
  const { navigate, setIsLoggedIn } = useRouter();

  const handleGoogleLogin = () => {
    setIsLoggedIn(true);
    navigate("dashboard");
  };

  return (
    <div className="min-h-screen flex relative overflow-hidden">
      {/* Left Panel - Branding */}
      <div className="hidden lg:flex lg:w-1/2 bg-gradient-to-br from-indigo-600 via-violet-600 to-purple-700 p-12 flex-col justify-between relative">
        <div className="absolute inset-0 overflow-hidden">
          <div className="absolute top-20 -left-20 w-80 h-80 bg-white/10 rounded-full blur-3xl" />
          <div className="absolute bottom-20 right-10 w-60 h-60 bg-white/5 rounded-full blur-3xl" />
          <div className="absolute top-1/2 left-1/3 w-40 h-40 bg-violet-400/10 rounded-full blur-2xl" />
          {/* Grid pattern */}
          <div className="absolute inset-0 opacity-[0.03]" style={{
            backgroundImage: 'radial-gradient(circle, white 1px, transparent 1px)',
            backgroundSize: '30px 30px'
          }} />
        </div>

        <div className="relative">
          <div className="flex items-center gap-3 mb-2">
            <div className="w-11 h-11 rounded-xl bg-white/20 backdrop-blur flex items-center justify-center border border-white/20">
              <GraduationCap className="w-6 h-6 text-white" />
            </div>
            <span className="text-2xl font-bold text-white">UniHub</span>
          </div>
        </div>

        <div className="relative space-y-6">
          <h2 className="text-4xl font-bold text-white leading-tight">
            Your campus.<br />Your community.<br />Your growth.
          </h2>
          <p className="text-indigo-100 text-lg max-w-md leading-relaxed">
            Join the platform that connects students across faculties, powers learning with AI, and prioritizes your well-being.
          </p>
          <div className="flex items-center gap-4 pt-4">
            {[
              { value: "500+", label: "Students" },
              { value: "12", label: "Faculties" },
              { value: "50+", label: "Courses" },
            ].map((stat) => (
              <div key={stat.label} className="text-center px-5 py-3 bg-white/10 rounded-xl backdrop-blur-sm border border-white/10">
                <div className="text-2xl font-bold text-white">{stat.value}</div>
                <div className="text-xs text-indigo-200">{stat.label}</div>
              </div>
            ))}
          </div>
        </div>

        <div className="relative text-indigo-200 text-sm">
          © 2025 UniHub · Google Solution Challenge
        </div>
      </div>

      {/* Right Panel - Login Form */}
      <div className="w-full lg:w-1/2 flex items-center justify-center p-8 bg-gradient-to-b from-gray-50 to-white">
        <div className="w-full max-w-md">
          <button
            onClick={() => navigate("landing")}
            className="flex items-center gap-2 text-sm text-gray-500 hover:text-indigo-600 transition-colors mb-8 group"
          >
            <ArrowLeft className="w-4 h-4 group-hover:-translate-x-1 transition-transform" />
            Back to home
          </button>

          {/* Mobile logo */}
          <div className="lg:hidden flex items-center gap-2 mb-8">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-indigo-600 to-violet-600 flex items-center justify-center shadow-lg shadow-indigo-200">
              <GraduationCap className="w-5 h-5 text-white" />
            </div>
            <span className="text-xl font-bold bg-gradient-to-r from-indigo-700 to-violet-600 bg-clip-text text-transparent">UniHub</span>
          </div>

          <div className="space-y-2 mb-10">
            <h1 className="text-3xl font-bold text-gray-900">Welcome back 👋</h1>
            <p className="text-gray-500">Sign in with your university Google account to continue.</p>
          </div>

          <div className="space-y-6">
            {/* Google Login Button */}
            <button
              onClick={handleGoogleLogin}
              className="group w-full flex items-center justify-center gap-3 px-6 py-4 bg-white border-2 border-gray-200 rounded-xl hover:border-indigo-300 hover:bg-indigo-50/30 transition-all hover:shadow-lg hover:shadow-indigo-100 hover:-translate-y-0.5"
            >
              <svg viewBox="0 0 24 24" className="w-5 h-5" xmlns="http://www.w3.org/2000/svg">
                <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 0 1-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z" fill="#4285F4" />
                <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853" />
                <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05" />
                <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335" />
              </svg>
              <span className="font-semibold text-gray-700 group-hover:text-indigo-700 transition-colors">
                Continue with Google
              </span>
            </button>

            <div className="relative">
              <div className="absolute inset-0 flex items-center"><div className="w-full border-t border-gray-200" /></div>
              <div className="relative flex justify-center text-xs">
                <span className="bg-gradient-to-b from-gray-50 to-white px-4 text-gray-400">University account required</span>
              </div>
            </div>

            {/* Info Card */}
            <div className="bg-gradient-to-br from-indigo-50 to-violet-50 rounded-xl p-5 border border-indigo-100">
              <div className="flex items-start gap-3">
                <div className="w-10 h-10 rounded-lg bg-indigo-100 flex items-center justify-center shrink-0">
                  <GraduationCap className="w-5 h-5 text-indigo-600" />
                </div>
                <div>
                  <h3 className="font-semibold text-indigo-900 text-sm mb-1">UM Students Only</h3>
                  <p className="text-sm text-indigo-700/70 leading-relaxed">
                    Please use your <span className="font-medium text-indigo-700">@um.edu.my</span> or <span className="font-medium text-indigo-700">@siswa.um.edu.my</span> Google account to sign in. This ensures a safe and verified community.
                  </p>
                </div>
              </div>
            </div>

            {/* Features list */}
            <div className="space-y-3 pt-2">
              {[
                "🔒 Secure OAuth 2.0 authentication",
                "🎓 Auto-detect your faculty from student email",
                "⚡ One-click login, no passwords needed",
              ].map((item) => (
                <div key={item} className="flex items-center gap-3 text-sm text-gray-600">
                  <span>{item}</span>
                </div>
              ))}
            </div>
          </div>

          <p className="mt-8 text-xs text-gray-400 text-center leading-relaxed">
            By signing in, you agree to our Terms of Service and Privacy Policy.
            <br />Your data is protected under PDPA Malaysia.
          </p>
        </div>
      </div>
    </div>
  );
}
