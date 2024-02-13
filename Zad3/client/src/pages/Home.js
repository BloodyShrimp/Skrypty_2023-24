import React from "react";
import axios from "axios";
import { useEffect, useState } from "react";
import { useCart } from "../CartContext";

function Home() {
  const { addToCart } = useCart();
  const [listOfProducts, setListOfProducts] = useState([]);
  const [quantities, setQuantities] = useState({});

  useEffect(() => {
    axios.get("http://localhost:3001/products").then((response) => {
      setListOfProducts(response.data);
    });
  }, []);

  const handleAddToCart = (product) => {
    addToCart({ ...product, quantity: quantities[product.id] || 1 });
    setQuantities((prevQuantities) => ({
      ...prevQuantities,
      [product.id]: 1,
    }));
  };

  const handleQuantityChange = (productId, newQuantity) => {
    setQuantities((prevQuantities) => ({
      ...prevQuantities,
      [productId]: newQuantity,
    }));
  };

  return (
    <div className="grid-container">
      {listOfProducts.map((value, key) => (
        <div className="item" key={key}>
          <img src={value.image} alt="product" />
          <div className="name">{value.name}</div>
          <div className="price">${value.price}</div>
          <div>
            <label htmlFor={`quantity-${key}`}>Quantity:</label>
            <input
              type="number"
              id={`quantity-${key}`}
              value={quantities[value.id] || 1}
              onChange={(e) =>
                handleQuantityChange(value.id, parseInt(e.target.value, 10))
              }
              min="1"
            />
          </div>
          <button
            className="add-to-cart"
            onClick={() => handleAddToCart(value)}
          >
            Add to cart
          </button>
        </div>
      ))}
    </div>
  );
}

export default Home;
