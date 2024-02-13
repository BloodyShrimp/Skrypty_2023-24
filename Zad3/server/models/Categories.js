module.exports = (sequelize, DataTypes) => {
    const Categories = sequelize.define("Categories", {
      name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
    });
  
    Categories.associate = (models) => {
      Categories.hasMany(models.Products, { foreignKey: "categoryId" });
    };
  
    return Categories;
  };
  