-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema SistemaVentas
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema SistemaVentas
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `SistemaVentas` DEFAULT CHARACTER SET utf8 ;
USE `SistemaVentas` ;

-- -----------------------------------------------------
-- Table `SistemaVentas`.`Proveedores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaVentas`.`Proveedores` (
  `ID_Proveedor` INT NOT NULL,
  `Nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_Proveedor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaVentas`.`Productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaVentas`.`Productos` (
  `ID_Producto` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Nombre_Producto` VARCHAR(50) NULL,
  `Descripcion` VARCHAR(45) NULL,
  `Producto_Descripcion` VARCHAR(255) NULL,
  `Color` VARCHAR(45) NULL,
  `Prod_Prov` INT NULL,
  `Proveedores_ID_Proveedor` INT NOT NULL,
  PRIMARY KEY (`ID_Producto`, `Proveedores_ID_Proveedor`),
  INDEX `fk_Productos_Proveedores_idx` (`Proveedores_ID_Proveedor` ASC) VISIBLE,
  CONSTRAINT `fk_Productos_Proveedores`
    FOREIGN KEY (`Proveedores_ID_Proveedor`)
    REFERENCES `SistemaVentas`.`Proveedores` (`ID_Proveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaVentas`.`Clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaVentas`.`Clientes` (
  `ID_Cliente` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_Cliente`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaVentas`.`Categorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaVentas`.`Categorias` (
  `ID_Categorias` INT NOT NULL,
  `Nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_Categorias`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaVentas`.`Categorias_has_Productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaVentas`.`Categorias_has_Productos` (
  `Categorias_ID_Categorias` INT NOT NULL,
  `Productos_ID_Producto` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Categorias_ID_Categorias`, `Productos_ID_Producto`),
  INDEX `fk_Categorias_has_Productos_Productos1_idx` (`Productos_ID_Producto` ASC) VISIBLE,
  INDEX `fk_Categorias_has_Productos_Categorias1_idx` (`Categorias_ID_Categorias` ASC) VISIBLE,
  CONSTRAINT `fk_Categorias_has_Productos_Categorias1`
    FOREIGN KEY (`Categorias_ID_Categorias`)
    REFERENCES `SistemaVentas`.`Categorias` (`ID_Categorias`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Categorias_has_Productos_Productos1`
    FOREIGN KEY (`Productos_ID_Producto`)
    REFERENCES `SistemaVentas`.`Productos` (`ID_Producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaVentas`.`Precios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaVentas`.`Precios` (
  `ID_Precios` INT NOT NULL AUTO_INCREMENT,
  `Precio_IDProd` INT NULL,
  `Precios_Valor` DECIMAL(10,3) UNSIGNED NOT NULL,
  `Productos_ID_Producto` INT UNSIGNED NOT NULL,
  `Productos_Proveedores_ID_Proveedor` INT NOT NULL,
  PRIMARY KEY (`ID_Precios`),
  UNIQUE INDEX `Precio_IDProd_UNIQUE` (`Precio_IDProd` ASC) VISIBLE,
  INDEX `fk_Precios_Productos1_idx` (`Productos_ID_Producto` ASC, `Productos_Proveedores_ID_Proveedor` ASC) VISIBLE,
  CONSTRAINT `fk_Precios_Productos1`
    FOREIGN KEY (`Productos_ID_Producto` , `Productos_Proveedores_ID_Proveedor`)
    REFERENCES `SistemaVentas`.`Productos` (`ID_Producto` , `Proveedores_ID_Proveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaVentas`.`Ventas_Encabezado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaVentas`.`Ventas_Encabezado` (
  `ID_VentasE` BIGINT(10) NOT NULL,
  `Fecha_VentaE` DATE NULL,
  `IDClient_VentaE` INT NULL,
  `Total_VentaE` DECIMAL(10) NULL,
  `Clientes_ID_Cliente` INT NOT NULL,
  PRIMARY KEY (`ID_VentasE`),
  INDEX `fk_Ventas_Encabezado_Clientes1_idx` (`Clientes_ID_Cliente` ASC) VISIBLE,
  CONSTRAINT `fk_Ventas_Encabezado_Clientes1`
    FOREIGN KEY (`Clientes_ID_Cliente`)
    REFERENCES `SistemaVentas`.`Clientes` (`ID_Cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SistemaVentas`.`Detalle_Ventas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SistemaVentas`.`Detalle_Ventas` (
  `ID_VentasD` BIGINT(10) NOT NULL,
  `VentasD_VentasE` BIGINT(10) NULL,
  `DVentas_IDProd` INT NULL,
  `DVentas_Cantidad` MEDIUMINT(5) NULL,
  `Ventas_Encabezado_ID_VentasE` BIGINT(10) NOT NULL,
  `Productos_ID_Producto` INT UNSIGNED NOT NULL,
  `Productos_Proveedores_ID_Proveedor` INT NOT NULL,
  PRIMARY KEY (`ID_VentasD`, `Ventas_Encabezado_ID_VentasE`, `Productos_ID_Producto`, `Productos_Proveedores_ID_Proveedor`),
  INDEX `fk_Detalle_Ventas_Ventas_Encabezado1_idx` (`Ventas_Encabezado_ID_VentasE` ASC) VISIBLE,
  INDEX `fk_Detalle_Ventas_Productos1_idx` (`Productos_ID_Producto` ASC, `Productos_Proveedores_ID_Proveedor` ASC) VISIBLE,
  CONSTRAINT `fk_Detalle_Ventas_Ventas_Encabezado1`
    FOREIGN KEY (`Ventas_Encabezado_ID_VentasE`)
    REFERENCES `SistemaVentas`.`Ventas_Encabezado` (`ID_VentasE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Detalle_Ventas_Productos1`
    FOREIGN KEY (`Productos_ID_Producto` , `Productos_Proveedores_ID_Proveedor`)
    REFERENCES `SistemaVentas`.`Productos` (`ID_Producto` , `Proveedores_ID_Proveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
