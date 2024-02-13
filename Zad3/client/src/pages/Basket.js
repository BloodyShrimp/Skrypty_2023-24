import React from "react";
import { useCart } from "../CartContext";

function Basket() {
  const { cartItems, removeFromCart, clearCart, calculateTotalCost } =
    useCart();

  return (
    <div>
      <h2>Your Basket</h2>
      {cartItems.length === 0 ? (
        <p>Your basket is empty.</p>
      ) : (
        <>
          <ul>
            {cartItems.map((item) => (
              <li key={item.id}>
                <img src={item.image} alt={item.name} />
                <div>
                  <p>{item.name}</p>
                  <p>{item.price}</p>
                  <p>Quantity: {item.quantity}</p>
                </div>
                <button onClick={() => removeFromCart(item.id)}>Remove</button>
              </li>
            ))}
          </ul>
          <p>Total Cost: ${calculateTotalCost().toFixed(2)}</p>
          <button onClick={clearCart}>Clear Basket</button>
          <button className="buy">Buy</button>
        </>
      )}
    </div>
  );
}

export default Basket;
