import { createContext, useContext, useState } from "react";

const CartContext = createContext();

export const useCart = () => {
  return useContext(CartContext);
};

export const CartProvider = ({ children }) => {
    const [cartItems, setCartItems] = useState([]);
  
    const calculateTotalCost = () => {
      return cartItems.reduce((total, item) => {
        return total + item.quantity * item.price;
      }, 0);
    };
  
    const addToCart = (product) => {
      const existingItemIndex = cartItems.findIndex(
        (item) => item.id === product.id
      );
  
      if (existingItemIndex !== -1) {
        const updatedCartItems = [...cartItems];
        updatedCartItems[existingItemIndex].quantity += product.quantity;
        setCartItems(updatedCartItems);
      } else {
        setCartItems((prevItems) => [...prevItems, product]);
      }
    };

  const removeFromCart = (productId) => {
    setCartItems((prevItems) =>
      prevItems.filter((item) => item.id !== productId)
    );
  };

  const clearCart = () => {
    setCartItems([]);
  };

  return (
    <CartContext.Provider
      value={{ cartItems, addToCart, removeFromCart, clearCart, calculateTotalCost }}
    >
      {children}
    </CartContext.Provider>
  );
};