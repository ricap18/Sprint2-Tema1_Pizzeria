-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Pizzeria
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Pizzeria
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Pizzeria` DEFAULT CHARACTER SET utf8 ;
USE `Pizzeria` ;

-- -----------------------------------------------------
-- Table `Pizzeria`.`Clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pizzeria`.`Clientes` (
  `id_clientes` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido1` VARCHAR(45) NOT NULL,
  `apellido2` VARCHAR(45) NULL,
  `direccion` VARCHAR(45) NOT NULL,
  `codigo_postal` VARCHAR(10) NOT NULL,
  `localidad` VARCHAR(15) NOT NULL,
  `provincia` VARCHAR(45) NOT NULL,
  `telefono` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id_clientes`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pizzeria`.`Tiendas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pizzeria`.`Tiendas` (
  `id_tienda` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `direccion` VARCHAR(45) NOT NULL,
  `codigo_postal` VARCHAR(6) NOT NULL,
  `localidad` VARCHAR(45) NOT NULL,
  `provincia` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_tienda`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pizzeria`.`Empleados`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pizzeria`.`Empleados` (
  `id_empleado` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_tienda` INT UNSIGNED NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido1` VARCHAR(45) NOT NULL,
  `apellido2` VARCHAR(45) NOT NULL,
  `nif` VARCHAR(20) NOT NULL,
  `telefono` VARCHAR(20) NOT NULL,
  `tipo` ENUM('cocinero', 'repartidor') NULL,
  PRIMARY KEY (`id_empleado`),
  INDEX `id_tienda_idx` (`id_tienda` ASC) ,
  CONSTRAINT `fk_empleados_tiendas`
    FOREIGN KEY (`id_tienda`)
    REFERENCES `Pizzeria`.`Tiendas` (`id_tienda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pizzeria`.`Entregas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pizzeria`.`Entregas` (
  `id_entrega` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_empleado` INT UNSIGNED NOT NULL,
  `fecha_hora_entrega` DATETIME NOT NULL,
  PRIMARY KEY (`id_entrega`),
  INDEX `id_repartidor_idx` (`id_empleado` ASC) ,
  CONSTRAINT `fk_entregas_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `Pizzeria`.`Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pizzeria`.`Categorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pizzeria`.`Categorias` (
  `id_categorias` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_categorias`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pizzeria`.`Productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pizzeria`.`Productos` (
  `id_producto` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_categoria` INT UNSIGNED NULL,
  `tipo` ENUM("pizza", "hamburguesa", "bebida") NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` VARCHAR(45) NOT NULL,
  `imagen` BLOB NOT NULL,
  `precio` DOUBLE NOT NULL,
  PRIMARY KEY (`id_producto`),
  INDEX `fk_productos_categorias_idx` (`id_categoria` ASC) ,
  CONSTRAINT `fk_productos_categorias`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `Pizzeria`.`Categorias` (`id_categorias`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pizzeria`.`Cantidad_Producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pizzeria`.`Cantidad_Producto` (
  `id_cantidad_producto` INT NOT NULL AUTO_INCREMENT,
  `id_producto` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_cantidad_producto`),
  INDEX `fk_cantidad_producto_idx` (`id_producto` ASC) ,
  CONSTRAINT `fk_canPro_producto`
    FOREIGN KEY (`id_producto`)
    REFERENCES `Pizzeria`.`Productos` (`id_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Pizzeria`.`Pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Pizzeria`.`Pedido` (
  `id_pedido` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_cliente` INT UNSIGNED NOT NULL,
  `id_entrega` INT UNSIGNED NOT NULL,
  `id_catidad_producto` INT NOT NULL,
  `id_tienda` INT UNSIGNED NOT NULL,
  `fecha_hora` DATETIME NOT NULL,
  `tipo` ENUM('reparto', 'recoger_tienda') NOT NULL,
  `precio_total` DOUBLE NOT NULL,
  PRIMARY KEY (`id_pedido`),
  INDEX `id_clientes_idx` (`id_cliente` ASC) ,
  INDEX `fk_pedido_entregas_idx` (`id_entrega` ASC) ,
  INDEX `fk_pedido_tienda_idx` (`id_tienda` ASC) ,
  INDEX `fk_pedido_cantProd_idx` (`id_catidad_producto` ASC) ,
  CONSTRAINT `fk_pedido_clientes`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `Pizzeria`.`Clientes` (`id_clientes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_entregas`
    FOREIGN KEY (`id_entrega`)
    REFERENCES `Pizzeria`.`Entregas` (`id_entrega`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_tienda`
    FOREIGN KEY (`id_tienda`)
    REFERENCES `Pizzeria`.`Tiendas` (`id_tienda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_cantProd`
    FOREIGN KEY (`id_catidad_producto`)
    REFERENCES `Pizzeria`.`Cantidad_Producto` (`id_cantidad_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
