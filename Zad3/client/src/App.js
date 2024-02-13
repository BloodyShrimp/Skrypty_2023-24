import "./App.css";
import { BrowserRouter as Router, Route, Routes, Link } from "react-router-dom";
import Home from "./pages/Home";
import Basket from "./pages/Basket";

function App() {
  return (
    <div className="App">
      <Router>
        <div class="navbar">
          <Link to="/">Home</Link>
          <Link to="/basket">Basket</Link>
        </div>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/basket" element={<Basket />} />
        </Routes>
      </Router>
    </div>
  );
}

export default App;
