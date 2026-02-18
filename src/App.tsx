import { useState, createContext, useContext } from "react";
import { LandingPage } from "./pages/LandingPage";
import { LoginPage } from "./pages/LoginPage";
import { DashboardPage } from "./pages/DashboardPage";
import { NetworkPage } from "./pages/NetworkPage";
import { CoursesPage } from "./pages/CoursesPage";
import { WellnessPage } from "./pages/WellnessPage";
import { DecisionPage } from "./pages/DecisionPage";
import { ProfilePage } from "./pages/ProfilePage";
import { DashboardLayout } from "./components/DashboardLayout";

type Page = "landing" | "login" | "dashboard" | "network" | "courses" | "wellness" | "decision" | "profile";

interface RouterContextType {
  page: Page;
  navigate: (page: Page) => void;
  isLoggedIn: boolean;
  setIsLoggedIn: (v: boolean) => void;
  user: UserInfo;
}

interface UserInfo {
  name: string;
  email: string;
  avatar: string;
  faculty: string;
  year: string;
}

const defaultUser: UserInfo = {
  name: "Jia Qian",
  email: "jiaqian@um.edu.my",
  avatar: "",
  faculty: "Faculty of Computer Science & IT",
  year: "Year 3",
};

export const RouterContext = createContext<RouterContextType>({
  page: "landing",
  navigate: () => {},
  isLoggedIn: false,
  setIsLoggedIn: () => {},
  user: defaultUser,
});

export const useRouter = () => useContext(RouterContext);

export function App() {
  const [page, setPage] = useState<Page>("landing");
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  const navigate = (newPage: Page) => {
    setPage(newPage);
    window.scrollTo(0, 0);
  };

  const dashboardPages: Page[] = ["dashboard", "network", "courses", "wellness", "decision", "profile"];

  return (
    <RouterContext.Provider value={{ page, navigate, isLoggedIn, setIsLoggedIn, user: defaultUser }}>
      {page === "landing" && <LandingPage />}
      {page === "login" && <LoginPage />}
      {dashboardPages.includes(page) && (
        <DashboardLayout>
          {page === "dashboard" && <DashboardPage />}
          {page === "network" && <NetworkPage />}
          {page === "courses" && <CoursesPage />}
          {page === "wellness" && <WellnessPage />}
          {page === "decision" && <DecisionPage />}
          {page === "profile" && <ProfilePage />}
        </DashboardLayout>
      )}
    </RouterContext.Provider>
  );
}
