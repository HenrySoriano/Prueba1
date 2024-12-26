-- Schema sensei_data_prevention_dbb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `sensei_data_prevention_db` DEFAULT CHARACTER SET utf8mb4 ;
USE `sensei_data_prevention_dbb` ;
-- -----------------------------------------------------
-- Table `t000_Parte_diario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t000_Parte_diario` (
  `id_partediario` VARCHAR(255) NOT NULL PRIMARY KEY,
  `fecha` DATE NOT NULL,
  `hora` TIME NOT NULL,
  `id_empleado` VARCHAR(255) NOT NULL,
  `primera_atencion_mes` BOOLEAN NOT NULL,
  `id_causa` VARCHAR(255),
  `causa_atencion` VARCHAR(255),
  `tipo_atencion` ENUM('primera vez', 'subsecuente', 'control médico', 'inicio', 'pre ocupacional', 'periódica', 'retiro', 'reintegro') NOT NULL,
  `tipo_morbilidad` ENUM('laboral', 'no laboral') NOT NULL,
  `id_diagnostico` VARCHAR(255),
  `factor_riesgo` VARCHAR(255) NOT NULL,
  `dias_ausentismo` DECIMAL(10,2),
  `horas_ausentismo` DECIMAL(10,2),
  `id_usuario` VARCHAR(255),
  `informe` LONGBLOB,
  `telemedicina` BOOLEAN NOT NULL,
  `mes_año` DATE GENERATED ALWAYS AS (DATE_FORMAT(fecha, '%Y-%m-01')) STORED,
   INDEX `fk_parte_diario_empleados_idx` (`id_empleado` ASC),
   INDEX `fk_parte_diario_usuarios_idx` (`id_usuario` ASC),
   INDEX `fk_parte_diario_factores_idx` (`factor_riesgo` ASC),
  INDEX `fk_parte_diario_cie10_idx` (`id_diagnostico` ASC),
  INDEX `fecha_idx` (`fecha` ASC),
    INDEX `tipo_atencion_idx` (`tipo_atencion` ASC),
      INDEX `tipo_morbilidad_idx` (`tipo_morbilidad` ASC),
        INDEX `mes_año_idx` (`mes_año` ASC),
    CONSTRAINT `fk_parte_diario_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
   CONSTRAINT `fk_parte_diario_usuarios`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `t001_Usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_parte_diario_factores`
    FOREIGN KEY (`factor_riesgo`)
    REFERENCES `t037_Factores_reisgos` (`id_factor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
   CONSTRAINT `fk_parte_diario_cie10`
    FOREIGN KEY (`id_diagnostico`)
    REFERENCES `t008_Cie10` (`id_cie10`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t001_Usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t001_Usuarios` (
    `id_usuario` VARCHAR(255) NOT NULL PRIMARY KEY,
    `usuario` TEXT UNIQUE NOT NULL,
    `email` VARCHAR(255) UNIQUE NOT NULL,
    `contrasena` TEXT NOT NULL,
    `rol` ENUM('admin', 'médico', 'enfermero', 'inspector', 'trabajador') NOT NULL,
    `estado_licencia` ENUM('activo', 'inactivo') NOT NULL,
    `id_ubicacion` INT,
INDEX `fk_usuarios_ubicaciones_idx` (`id_ubicacion` ASC),
    CONSTRAINT `fk_usuarios_ubicaciones`
    FOREIGN KEY (`id_ubicacion`)
    REFERENCES `t011_Ciudades` (`id_ubicacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- Table `t002_Empresas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t002_Empresas` (
  `id_empresa` VARCHAR(255) NOT NULL PRIMARY KEY,
  `razon_social` TEXT NOT NULL,
  `ruc` VARCHAR(20) UNIQUE,
  `correo_empresarial` VARCHAR(255) UNIQUE NOT NULL,
  `direccion` TEXT NOT NULL,
  `ciiu` VARCHAR(20),
  `tipo_establecimiento` ENUM('privado', 'público', 'fundación', 'arquidiócesis') NOT NULL,
  `marca_comercial` TEXT,
  `establecimiento_salud` TEXT,
  `representante_legal` TEXT NOT NULL,
  `ubicacion_matriz` TEXT NOT NULL,
  `actividad_principal` TEXT NOT NULL,
  `telefono` TEXT NOT NULL,
  `responsable_sst` TEXT NOT NULL,
  `correo_sst` VARCHAR(255) UNIQUE NOT NULL,
  `celular_sst` TEXT NOT NULL,
  `logo_empresa` LONGBLOB,
  `tiene_sucursales` BOOLEAN NOT NULL,
  `id_ubicacion` INT,
  INDEX `fk_empresas_ubicaciones_idx` (`id_ubicacion` ASC),
  CONSTRAINT `fk_empresas_ubicaciones`
    FOREIGN KEY (`id_ubicacion`)
    REFERENCES `t011_Ciudades` (`id_ubicacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t002_Profesionales` (
    `id_profesional` VARCHAR(255) NOT NULL PRIMARY KEY,
    `apellidos` TEXT NOT NULL,
    `nombres` TEXT NOT NULL,
    `usuario` TEXT UNIQUE NOT NULL,
    `email` VARCHAR(255) UNIQUE NOT NULL,
    `contrasena` TEXT NOT NULL,
    `rol` ENUM('admin', 'médico', 'enfermero', 'inspector', 'trabajador') NOT NULL,
    `estado_contrato` ENUM('activo', 'inactivo') NOT NULL,
    `senescyt` VARCHAR(255),
    `profesion` TEXT NOT NULL,
    `especialidad` TEXT NOT NULL,
    `foto` LONGBLOB,
    `direccion` TEXT NOT NULL,
    `pais` TEXT NOT NULL,
    `provincia` TEXT NOT NULL,
    `ciudad` TEXT NOT NULL,
    `codigo_pais` TEXT NOT NULL,
    `celular` TEXT NOT NULL,
    `firma_digital` LONGBLOB NOT NULL,
    `sello_digital` LONGBLOB NOT NULL,
    `id_ubicacion` INT,
INDEX `fk_profesionales_ubicaciones_idx` (`id_ubicacion` ASC),
    CONSTRAINT `fk_profesionales_ubicaciones`
    FOREIGN KEY (`id_ubicacion`)
    REFERENCES `t011_Ciudades` (`id_ubicacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t004_Sucursales`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t004_Sucursales` (
    `id_sucursal` VARCHAR(255) NOT NULL PRIMARY KEY,
    `nombre_sucursal` TEXT NOT NULL,
    `id_empresa` VARCHAR(255) NOT NULL,
    `direccion` TEXT NOT NULL,
    `parroquia` TEXT,
    `telefono` TEXT NOT NULL,
    `correo` VARCHAR(255),
    `id_ubicacion` INT,
      INDEX `fk_sucursales_ubicaciones_idx` (`id_ubicacion` ASC),
     INDEX `fk_sucursales_empresas_idx` (`id_empresa` ASC),
    CONSTRAINT `fk_sucursales_ubicaciones`
    FOREIGN KEY (`id_ubicacion`)
    REFERENCES `t011_Ciudades` (`id_ubicacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
   CONSTRAINT `fk_sucursales_empresas`
    FOREIGN KEY (`id_empresa`)
    REFERENCES `t002_Empresas` (`id_empresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t005_Cargos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t005_Cargos` (
    `id_cargo` VARCHAR(255) NOT NULL PRIMARY KEY,
    `nombre_cargo` TEXT NOT NULL,
    `departamento` TEXT NOT NULL,
    `area` TEXT NOT NULL,
    `dias_laborables` ENUM('lunes a viernes', 'lunes a sábado', 'especial incluye domingo') NOT NULL,
    `horas_jornada` DECIMAL(10,2) NOT NULL,
    `tipo_trabajo` ENUM('administrativo', 'operativo', 'soporte', 'comercial', 'mixto', 'directivo', 'jefatura') NOT NULL,
    `id_empresa` VARCHAR(255) NOT NULL,
    `id_sucursal` VARCHAR(255),
    `estado` ENUM('activo', 'inactivo') NOT NULL,
    `salario_base` DECIMAL(10,2) NOT NULL,
    `costo_hora` DECIMAL(10,2) GENERATED ALWAYS AS (salario_base / (horas_jornada * (CASE WHEN dias_laborables = 'lunes a viernes' THEN 5 WHEN dias_laborables = 'lunes a sábado' THEN 6 ELSE 7 END) * 4)) STORED,
     INDEX `fk_cargos_empresas_idx` (`id_empresa` ASC),
    INDEX `fk_cargos_sucursales_idx` (`id_sucursal` ASC),
  CONSTRAINT `fk_cargos_empresas`
    FOREIGN KEY (`id_empresa`)
    REFERENCES `t002_Empresas` (`id_empresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
     CONSTRAINT `fk_cargos_sucursales`
    FOREIGN KEY (`id_sucursal`)
    REFERENCES `t004_Sucursales` (`id_sucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t007_Evaluacion_riesgo_cargo_actual`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t007_Evaluacion_riesgo_cargo_actual` (
  `id_evaluacion_actividad` VARCHAR(255) NOT NULL PRIMARY KEY,
  `actividad` TEXT,
  `id_empleado` VARCHAR(255),
  `id_cargo` VARCHAR(255),
  `fecha_evaluacion` DATE NOT NULL,
  `temperaturas_altas` BOOLEAN,
  `temperaturas_altas_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `temperaturas_bajas` BOOLEAN,
  `temperaturas_bajas_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `radiacion_ionizante` BOOLEAN,
  `radiacion_ionizante_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `radiacion_no_ionizante` BOOLEAN,
  `radiacion_no_ionizante_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `ruido` BOOLEAN,
  `ruido_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `vibracion` BOOLEAN,
  `vibracion_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `ventilacion` BOOLEAN,
  `ventilacion_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `iluminacion` BOOLEAN,
  `iluminacion_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `fluido_electrico` BOOLEAN,
  `fluido_electrico_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `trabajo_altura` BOOLEAN,
   `trabajo_altura_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `espacio_confinado` BOOLEAN,
 `espacio_confinado_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
   `atrapaentremaquina` BOOLEAN,
  `atrapaentremaquina_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
 `atrapaentresuperficie` BOOLEAN,
  `atrapaentresuperficie_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
    `Caidaobjetos` BOOLEAN,
  `Caidaobjetos_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `Caidanivel` BOOLEAN,
  `Caidanivel_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
   `caidadesnivel` BOOLEAN,
  `caidadesnivel_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `herramientas` BOOLEAN,
   `herramientas_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `pinchazos` BOOLEAN,
   `pinchazos_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `cortes` BOOLEAN,
   `cortes_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
   `proyeccion_particulas` BOOLEAN,
    `proyeccion_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
    `atropellamiento` BOOLEAN,
     `atropellamiento_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
 `choquevehiculo` BOOLEAN,
  `choquevehiculo_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `contacto_electrico` BOOLEAN,
   `contactoelectrico_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
   `superficie_trabajo` BOOLEAN,
   `superficie_trabajo_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
   `orden_limpieza` BOOLEAN,
  `orden_limpieza_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
   `solidos` BOOLEAN,
   `solidos_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
   `polvos` BOOLEAN,
   `polvos_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `humos` BOOLEAN,
    `humos_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
   `neblinas` BOOLEAN,
 `neblinas_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `gases` BOOLEAN,
    `gases_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
 `vapores` BOOLEAN,
    `vapores_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `liquidos` BOOLEAN,
   `liquidos_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
   `aerosoles` BOOLEAN,
  `aerosoles_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
   `virus` BOOLEAN,
    `virus_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
     `bacterias` BOOLEAN,
    `bacterias_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
   `hongos` BOOLEAN,
   `hongos_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `parasitos` BOOLEAN,
  `parasitos_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
    `vectores` BOOLEAN,
      `vectores_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
    `animalesselvaticos` BOOLEAN,
       `animalesselvaticos_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
   `postura_mantenida` BOOLEAN,
    `posturamantenida_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
   `postura_forzada` BOOLEAN,
    `posturaforzada_nivel` ENUM('critico', 'alto', 'medio', 'bajo', 'muy bajo'),
  `movimiento_repetitivo` BOOLEAN,
 `manipulacion_cargas` BOOLEAN,
 `pantalla_visualizacion` BOOLEAN,
   `alta_responsabilidad` BOOLEAN,
   `sobrecarga_mental` BOOLEAN,
  `minuciosidad` BOOLEAN,
    `trabajo_monotono` BOOLEAN,
    `turnos_rotativos` BOOLEAN,
    `relaciones_interpersonales` BOOLEAN,
    `medidas_preventivas` TEXT,
     INDEX `fk_factores_riesgo_puesto_empleados_idx` (`id_empleado` ASC),
    INDEX `fk_factores_riesgo_puesto_cargos_idx` (`id_cargo` ASC),
   CONSTRAINT `fk_factores_riesgo_puesto_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_factores_riesgo_puesto_cargos`
    FOREIGN KEY (`id_cargo`)
    REFERENCES `t005_Cargos` (`id_cargo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t008_Cie10`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t008_Cie10` (
    `id_cie10` VARCHAR(255) NOT NULL PRIMARY KEY,
    `codigo_cie10` VARCHAR(20),
    `descripcion` TEXT NOT NULL,
    `sistema_afectado` TEXT NOT NULL
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t009_Vademecun`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t009_Vademecun` (
    `id_medicamento` VARCHAR(255) NOT NULL PRIMARY KEY,
    `nombre_comercial` TEXT NOT NULL,
    `nombre_generico` TEXT NOT NULL,
    `concentracion` TEXT NOT NULL,
    `presentacion` ENUM('cápsulas', 'ampollas', 'comprimidos', 'tabletas', 'óvulos orales', 'óvulos vaginales', 'supositorio', 'sobres', 'ampollas bebibles', 'inhalador', 'aplicador', 'crema', 'ungüento', 'colirio', 'solución', 'pomada', 'frasco', 'envase') NOT NULL,
    `via_administracion` ENUM('vía oral', 'via sub lingual', 'vía intradérmica', 'via subcutánea', 'local', 'inhalatoria', 'intra vaginal', 'intra rectal') NOT NULL,
    `dosis_recomendada` ENUM('1', '2', '3', '4', '6', '8', '12') NOT NULL,
    `frecuencia_recomendada` ENUM('1 vez al día', '1 cada 12 horas', '1 cada 8 horas', '1 cada 6 horas', '1 cada 4 horas', '1 cada 3 horas', '1 cada 2 horas') NOT NULL
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t011_Ciudades`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t011_Ciudades` (
  `id_ubicacion` INT AUTO_INCREMENT PRIMARY KEY,
  `pais` VARCHAR(100) NOT NULL,
  `provincia` VARCHAR(100),
  `ciudad` VARCHAR(100),
  `parroquia` VARCHAR(100),
  `codigotelefonico_pais` VARCHAR(10),
  UNIQUE INDEX `unique_location` (`pais` ASC, `provincia` ASC, `ciudad` ASC, `parroquia` ASC)
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t012_Empleados`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t012_Empleados` (
    `id_empleado` VARCHAR(255) NOT NULL PRIMARY KEY,
    `id_empresa` VARCHAR(255) NOT NULL,
    `id_sucursal` VARCHAR(255),
    `cedula` VARCHAR(20) UNIQUE,
    `primer_apellido` TEXT NOT NULL,
    `segundo_apellido` TEXT NOT NULL,
    `primer_nombre` TEXT NOT NULL,
    `segundo_nombre` TEXT,
    `sexo` ENUM('hombre', 'mujer') NOT NULL,
    `religion` ENUM('católico', 'evangélico', 'mormón', 'otros') NOT NULL,
    `tipo_sangre` ENUM('a+', 'a-', 'b+', 'b-', 'o+', 'o-', 'ab+', 'ab-') NOT NULL,
    `lateralidad` ENUM('diestro', 'zurdo', 'ambidiestro') NOT NULL,
    `fecha_nacimiento` DATE NOT NULL,
    `orientacion_sexual` VARCHAR(50) NOT NULL,
    `identidad_genero` VARCHAR(50) NOT NULL,
    `grupo_vulnerable` BOOLEAN NOT NULL,
    `vulnerabilidad` ENUM('no aplica', 'enfermedad crónica', 'discapacidad', 'lactancia', 'embarazo', 'ppl') NOT NULL,
    `tipo_discapacidad` ENUM('física', 'intelectual', 'auditiva', 'motriz', 'visual', 'no aplica') NOT NULL,
    `alergico` BOOLEAN NOT NULL,
    `detalle_alergia` TEXT,
    `antecedente_medico` TEXT,
    `porcentaje_discapacidad` DECIMAL(5,2),
    `fecha_ingreso` DATE NOT NULL,
    `id_cargo` VARCHAR(255) NOT NULL,
    `nivel_instruccion` TEXT,
    `estado_civil` VARCHAR(20) NOT NULL,
    `direccion_domicilio` TEXT NOT NULL,
    `celular` TEXT NOT NULL,
    `correo_personal` VARCHAR(255) NOT NULL,
    `tipo_transporte` ENUM('público', 'privado') NOT NULL,
    `tipo_licencia` ENUM('no aplica', 'tipo a', 'tipo b', 'tipo c', 'tipo e', 'tipo f'),
    `estado_empleado` ENUM('activo', 'inactivo') NOT NULL,
    `tipo_contrato` ENUM('contratista', 'nomina') NOT NULL,
    `fecha_salida` DATE,
    `fecha_reintegro` DATE,
    `jefe_inmediato` VARCHAR(255),
     INDEX `fk_empleados_empresas_idx` (`id_empresa` ASC),
     INDEX `fk_empleados_cargos_idx` (`id_cargo` ASC),
      INDEX `fk_empleados_sucursales_idx` (`id_sucursal` ASC),
      INDEX `fk_empleados_jefe_idx` (`jefe_inmediato` ASC),
  CONSTRAINT `fk_empleados_empresas`
    FOREIGN KEY (`id_empresa`)
    REFERENCES `t002_Empresas` (`id_empresa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
     CONSTRAINT `fk_empleados_cargos`
    FOREIGN KEY (`id_cargo`)
    REFERENCES `t005_Cargos` (`id_cargo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_empleados_sucursales`
    FOREIGN KEY (`id_sucursal`)
    REFERENCES `t004_Sucursales` (`id_sucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
   CONSTRAINT `fk_empleados_jefe`
    FOREIGN KEY (`jefe_inmediato`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t013_Antecedentes_personales_clinicosyquirurgicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t013_Antecedentes_personales_clinicosyquirurgicos` (
    `id_antecedente` VARCHAR(255) NOT NULL PRIMARY KEY,
    `id_empleado` VARCHAR(255) NOT NULL,
   `id_hco` INT NOT NULL,
    `fecha_registro` DATE NOT NULL,
    `antec_clinicos` TEXT,
    `antec_quirurgicos` TEXT,
    `antec_traumatologicos` TEXT,
    `antec_alergicos` TEXT,
    `observaciones` TEXT,
      INDEX `fk_antecedentes_personales_empleados_idx` (`id_empleado` ASC),
    INDEX `fk_antecedentes_personales_hco_idx` (`id_hco` ASC),
    CONSTRAINT `fk_antecedentes_personales_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_antecedentes_personales_hco`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t014_Antecedentes_ginceco-obstetricos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t014_Antecedentes_ginceco-obstetricos` (
    `id_antecedente` VARCHAR(255) NOT NULL PRIMARY KEY,
    `id_empleado` VARCHAR(255) NOT NULL,
   `id_hco` INT NOT NULL,
    `fecha_registro` DATE NOT NULL,
    `menarquia` DECIMAL(10,2),
    `ciclos_menstruales` TEXT,
    `fecha_ultima_menstruacion` DATE,
    `gestas` DECIMAL(10,2),
    `partos` DECIMAL(10,2),
    `cesareas` DECIMAL(10,2),
    `abortos` DECIMAL(10,2),
    `hijos_muertos` DECIMAL(10,2),
    `hijos_vivos` DECIMAL(10,2),
    `menoresdeedad` BOOLEAN,
    `hijo_grupovulnerable` BOOLEAN,
    `hijo_grupvulncual` VARCHAR(50),
    `hijo_grupvulndescrip` TEXT,
    `metodo_planificacion` TEXT,
    `papanicolaou` BOOLEAN,
    `fecha_ultimo_pap` DATE,
    `resultado_pap` TEXT,
    `mamografia` BOOLEAN,
    `fecha_ultima_mamografia` DATE,
    `resultado_mamografia` TEXT,
     INDEX `fk_antecedentes_femeninos_empleados_idx` (`id_empleado` ASC),
    INDEX `fk_antecedentes_femeninos_hco_idx` (`id_hco` ASC),
    CONSTRAINT `fk_antecedentes_femeninos_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_antecedentes_femeninos_hco`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t015_Antecedentes_reproductivos_masculinos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t015_Antecedentes_reproductivos_masculinos` (
    `id_antecedente` VARCHAR(255) NOT NULL PRIMARY KEY,
    `id_empleado` VARCHAR(255) NOT NULL,
  `id_hco` INT NOT NULL,
    `fecha_registro` DATE NOT NULL,
    `antigeno_prostatico` BOOLEAN,
    `fecha_ultimo_antigeno` DATE,
    `resultado_antigeno` TEXT,
    `eco_prostatica` BOOLEAN,
    `fecha_ultima_eco` DATE,
    `resultado_eco` TEXT,
    `metodo_planificacion` TEXT,
    `muertos_hijos` DECIMAL(10,2),
    `vivos_hijos` DECIMAL(10,2),
    `menoresdeedad` BOOLEAN,
    `hijo_grupovulnerable` BOOLEAN,
    `hijo_grupvulncual` VARCHAR(50),
    `hijo_grupvulndescrip` TEXT,
    `observaciones` TEXT,
      INDEX `fk_antecedentes_masculinos_empleados_idx` (`id_empleado` ASC),
    INDEX `fk_antecedentes_masculinos_hco_idx` (`id_hco` ASC),
    CONSTRAINT `fk_antecedentes_masculinos_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
     CONSTRAINT `fk_antecedentes_masculinos_hco`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t016_Habitos_estilovida`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t016_Habitos_estilovida` (
    `id_habito` VARCHAR(255) NOT NULL PRIMARY KEY,
    `id_empleado` VARCHAR(255) NOT NULL,
  `id_hco` INT NOT NULL,
    `fecha_registro` DATE NOT NULL,
    `consume_tabaco` BOOLEAN NOT NULL,
    `tiempo_consumo_tabaco` TEXT,
    `cantidad_tabaco` TEXT,
    `ex_consumidor_tabaco` BOOLEAN,
    `tiempo_abstinencia_tabaco` TEXT,
    `consume_alcohol` BOOLEAN NOT NULL,
    `tiempo_consumo_alcohol` TEXT,
    `cantidad_alcohol` TEXT,
    `ex_consumidor_alcohol` BOOLEAN,
    `tiempo_abstinencia_alcohol` TEXT,
    `consume_drogas` BOOLEAN NOT NULL,
    `tiempo_consumo_drogas` TEXT,
    `cantidad_drogas` TEXT,
    `ex_consumidor_drogas` BOOLEAN,
    `tiempo_abstinencia_drogas` TEXT,
`recibio_capacitacion` JSON,
`principal_droga_consume` JSON,
`frecuencia` JSON,
`reconoce_tener_problema` ENUM('si', 'no', 'no aplica'),
    `recibido_tratamiento` ENUM('si', 'no', 'no aplica'),
   `examen_preocupacional` ENUM('si', 'no', 'no aplica'),
`actividad_fisica` BOOLEAN NOT NULL,
    `tipo_actividad_fisica` TEXT,
    `frecuencia_actividad_fisica` TEXT,
    `medicacion_regular` BOOLEAN NOT NULL,
    `detalle_medicacion` TEXT,
    INDEX `fk_habitos_empleados_idx` (`id_empleado` ASC),
    INDEX `fk_habitos_hco_idx` (`id_hco` ASC),
    CONSTRAINT `fk_habitos_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
     CONSTRAINT `fk_habitos_hco`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t018_Antecedentes_laborales`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t018_Antecedentes_laborales` (
  `id_antecedente` VARCHAR(255) NOT NULL PRIMARY KEY,
  `id_empleado` VARCHAR(255) NOT NULL,
  `id_hco` INT NOT NULL,
  `empresa_anterior` TEXT NOT NULL,
  `puesto_anterior` TEXT NOT NULL,
  `actividades_principales` TEXT NOT NULL,
  `tiempo_trabajo` TEXT NOT NULL,
  `riesgos_fisicos` BOOLEAN,
  `riesgos_mecanicos` BOOLEAN,
  `riesgos_quimicos` BOOLEAN,
  `riesgos_biologicos` BOOLEAN,
  `riesgos_ergonomicos` BOOLEAN,
  `riesgos_psicosociales` BOOLEAN,
  `observaciones` TEXT,
  `epp_utilizados` TEXT,
    INDEX `fk_antecedentes_laborales_empleados_idx` (`id_empleado` ASC),
    INDEX `fk_antecedentes_laborales_hco_idx` (`id_hco` ASC),
    CONSTRAINT `fk_antecedentes_laborales_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
      CONSTRAINT `fk_antecedentes_laborales_hco`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t019_AntecedentesAT_EP`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t019_AntecedentesAT_EP` (
  `id_antecedente` VARCHAR(255) NOT NULL PRIMARY KEY,
  `id_empleado` VARCHAR(255) NOT NULL,
 `id_hco` INT NOT NULL,
  `tuvo_accidentes` BOOLEAN NOT NULL,
  `descripcion_accidente` TEXT,
  `fecha_accidente` DATE,
  `secuelas_accidente` TEXT,
  `tuvo_enf_profesional` BOOLEAN NOT NULL,
  `descripcion_enfermedad` TEXT,
  `fecha_diagnostico` DATE,
  `secuelas_enfermedad` TEXT,
  INDEX `fk_antecedentes_at_ep_empleados_idx` (`id_empleado` ASC),
    INDEX `fk_antecedentes_at_ep_hco_idx` (`id_hco` ASC),
     CONSTRAINT `fk_antecedentes_at_ep_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
       CONSTRAINT `fk_antecedentes_at_ep_hco`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t021_Incidentes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t021_Incidentes` (
  `id_incidente` VARCHAR(255) NOT NULL PRIMARY KEY,
  `id_empleado` VARCHAR(255) NOT NULL,
 `id_hco` INT NOT NULL,
  `tuvo_incidente` BOOLEAN NOT NULL,
  `descripcion_incidente` TEXT,
  `fecha_incidente` DATE,
  INDEX `fk_incidente_idx` (`id_empleado` ASC),
    INDEX `fk_incidente_idx` (`id_hco` ASC),
     CONSTRAINT `fk_incidente_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
       CONSTRAINT `fk_incidente_hco`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t022_Antecedentes_familiares`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t022_Antecedentes_familiares` (
    `id_antecedente` VARCHAR(255) NOT NULL PRIMARY KEY,
    `id_empleado` VARCHAR(255) NOT NULL,
   `id_hco` INT NOT NULL,
   `enf_cardiovasculares` BOOLEAN,
  `enf_metabolicas` BOOLEAN,
  `enf_neurologicas` BOOLEAN,
  `enf_oncologicas` BOOLEAN,
  `diagnostico_onc_familiar` TEXT,
  `enf_infecciosas` BOOLEAN,
  `enf_hereditarias` BOOLEAN,
  `discapacidades` BOOLEAN,
  `otras_relevantes` TEXT,
   `descripcion_detallada` TEXT,
       INDEX `fk_antecedentes_familiares_empleados_idx` (`id_empleado` ASC),
    INDEX `fk_antecedentes_familiares_hco_idx` (`id_hco` ASC),
    CONSTRAINT `fk_antecedentes_familiares_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
      CONSTRAINT `fk_antecedentes_familiares_hco`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t023_Actividad_extralaboral`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t023_Actividad_extralaboral` (
    `id_extralaboral` VARCHAR(255) NOT NULL PRIMARY KEY,
    `id_empleado` VARCHAR(255) NOT NULL,
  `id_hco` INT NOT NULL,
    `realiza_actividad` BOOLEAN NOT NULL,
    `tipo_actividad` TEXT,
    `tiempo_dedicacion` TEXT,
    `usa_epp` BOOLEAN,
    `tipo_epp` TEXT,
    `observaciones` TEXT,
     INDEX `fk_antecedentes_extralab_empleados_idx` (`id_empleado` ASC),
    INDEX `fk_antecedentes_extralab_hco_idx` (`id_hco` ASC),
    CONSTRAINT `fk_antecedentes_extralab_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_antecedentes_extralab_hco`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t024_Historiaclinica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t024_Historiaclinica` (
  `id_hco` INT AUTO_INCREMENT PRIMARY KEY,
  `id_empleado` VARCHAR(255) NOT NULL,
  `fecha_atencion` DATE NOT NULL,
  `hora_atencion` TIME NOT NULL,
  `tipo_registro` ENUM('hco', 'ambulatoria') NOT NULL,
  `tipo_evaluacion` ENUM('inicio', 'ingreso', 'periódica', 'retiro', 'reintegro', 'especial', 'ambulatoria') NOT NULL,
  `modalidad_atencion` ENUM('presencial', 'virtual') NOT NULL,
  `motivo_consulta` TEXT NOT NULL,
  `evolucion` TEXT NOT NULL,
    INDEX `fk_historia_clinica_empleados_idx` (`id_empleado` ASC),
    INDEX `fecha_atencion_idx` (`fecha_atencion` ASC),
    INDEX `tipo_evaluacion_idx` (`tipo_evaluacion` ASC),
  CONSTRAINT `fk_historia_clinica_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t026_Revision_actual_organosysistemas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t026_Revision_actual_organosysistemas` (
`id_hco_revisionorganossistemas` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
    `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
    `1.piel_anexos` ENUM('s/p', 'c/p'),
    `2.órganos_sentidos` ENUM('s/p', 'c/p'),
    `3.respiratorio` ENUM('s/p', 'c/p'),
    `4.cardiovascular` ENUM('s/p', 'c/p'),
    `5.digestivo` ENUM('s/p', 'c/p'),
    `6.genito-urinario` ENUM('s/p', 'c/p'),
    `7.musculoesqueléticos` ENUM('s/p', 'c/p'),
    `8.endocrino` ENUM('s/p', 'c/p'),
    `9.hemolinfatico` ENUM('s/p', 'c/p'),
    `10.nervioso` ENUM('s/p', 'c/p'),
    `descripción_revision_organosysistemas` ENUM('s/p', 'c/p'),
     INDEX `fk_hco_revisionorganossistemas_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_revisionorganossistemas`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t027_Constantes_vitales_antropometria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t027_Constantes_vitales_antropometria` (
`id_hco_antropometria` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
    `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
    `presion_arterial` 
    `temperatura` DECIMAL(5,2),
    `frecuencia_cardiaca` DECIMAL(5,2),
    `saturacion_o2` DECIMAL(5,2),
    `frecuencia_respiratoria` DECIMAL(5,2),
    `peso` DECIMAL(5,2),
    `talla` DECIMAL(5,2),
     `imc` DECIMAL(5,2) GENERATED ALWAYS AS (peso / (talla * talla)) STORED,
    `perimetro_abdominal` DECIMAL(5,2),
     INDEX `fk_hco_antropometria_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_antropometria`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t028_Examen_fisico_regional`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t028_Examen_fisico_regional` (
`id_hco_examenfisicoregional` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
    `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
`1a.piel_cicatrices`  ENUM('s/p', 'c/p'),
`1b.piel_tatuajes`  ENUM('s/p', 'c/p'),
`1c.Piel_y_faneras`  ENUM('s/p', 'c/p'),
`2a.ojos_parpados`  ENUM('s/p', 'c/p'),
`2b.ojos_conjuntivas`  ENUM('s/p', 'c/p'),
`2c.ojos_pupilas`  ENUM('s/p', 'c/p'),
`2d.ojos_cornea`  ENUM('s/p', 'c/p'),
`2e.ojos_motilidad`  ENUM('s/p', 'c/p'),
`3a.conducto_auditivo_externo`  ENUM('s/p', 'c/p'),
`3b.Pabellon`  ENUM('s/p', 'c/p'),
`3c.oido_pabellon`  ENUM('s/p', 'c/p'),
`4a.orofaringe_labios`  ENUM('s/p', 'c/p'),
`4b.orofaringe_lengua`  ENUM('s/p', 'c/p'),
`4c.orofaringe_faringe`  ENUM('s/p', 'c/p'),
`4d.orofaringe_amígdalas`  ENUM('s/p', 'c/p'),
`4e.orofaringe_dentadura`  ENUM('s/p', 'c/p'),
`5a.nariz_tabique`  ENUM('s/p', 'c/p'),
`5b.nariz_cornetes`  ENUM('s/p', 'c/p'),
`5c.nariz_mucosas`  ENUM('s/p', 'c/p'),
`5d.nariz_senos paranasales`  ENUM('s/p', 'c/p'),
`6a.cuello_tiroides_masas`  ENUM('s/p', 'c/p'),
`6b.cuello_movilidad`  ENUM('s/p', 'c/p'),
`7a.torax_mamas`  ENUM('s/p', 'c/p'),
`7b.torax_corazón`  ENUM('s/p', 'c/p'),
`8a.torax_pulmones`  ENUM('s/p', 'c/p'),
`8b.torax_parrilla costal`  ENUM('s/p', 'c/p'),
`9a.abdomen_vísceras`  ENUM('s/p', 'c/p'),
`9b.abdomen_pared_abdominal`  ENUM('s/p', 'c/p'),
`10a.columna_flexibilidad`  ENUM('s/p', 'c/p'),
`10b.columna_desviación`  ENUM('s/p', 'c/p'),
`10c.columna_dolor`  ENUM('s/p', 'c/p'),
`11a.pelvis`  ENUM('s/p', 'c/p'),
`11b.pelvis_genitales`  ENUM('s/p', 'c/p'),
`12a.extremidades_vascular`  ENUM('s/p', 'c/p'),
`12b.extremidades_miembros superiores`  ENUM('s/p', 'c/p'),
`12c.extremidades_miembros inferiores`  ENUM('s/p', 'c/p'),
`13a.neurologico_fuerza`  ENUM('s/p', 'c/p'),
`13b.neurologico_sensibilidad`  ENUM('s/p', 'c/p'),
`13c.neurologico_marcha`  ENUM('s/p', 'c/p'),
`13d.neurologico_reflejos`  ENUM('s/p', 'c/p'),
`observaciones_exf_regional` TEXT,
     INDEX `fk_hco_examenfisicoregional_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_examenfisicoregional`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_PielAnexos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_PielAnexos` (
 `id_hco_pielanexos` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
    `piel_anexos` ENUM('s/p', 'c/p'),
  `descripcion_pielanexos` JSON,
  `Piel` VARCHAR(255),
  `Uñas` VARCHAR(255),
  `Cabello` VARCHAR(255),
  `Lesiones` VARCHAR(255),
  `Hallazgos_anormales` VARCHAR(255),
    INDEX `fk_hco_pielanexos_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_pielanexos`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_OrganosSentidos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_OrganosSentidos` (
 `id_hco_organos` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
     `organos_sentidos` ENUM('s/p', 'c/p'),
    `descripcion_sentidos` JSON,
   `Vision` VARCHAR(255),
    `Audicion` VARCHAR(255),
    `Olfato` VARCHAR(255),
    `Gusto` VARCHAR(255),
    `Tacto` VARCHAR(255),
    `Equilibrio` VARCHAR(255),
    `Hallazgos_específicos` VARCHAR(255),
        INDEX `fk_hco_organos_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_organos`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_Respiratorio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_Respiratorio` (
 `id_hco_respiratorio` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
     `respiratorio` ENUM('s/p', 'c/p'),
    `descripcion_respiratorio` JSON,
   `Via_Aerea_Superior` VARCHAR(255),
  `Via_Aerea_Inferior` VARCHAR(255),
  `Torax` VARCHAR(255),
  `Palpacion` VARCHAR(255),
  `Percusion` VARCHAR(255),
  `Auscultacion` VARCHAR(255),
     INDEX `fk_hco_respiratorio_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_respiratorio`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_Cardiovascular`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_Cardiovascular` (
`id_hco_cardio` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
   `cardiovascular` ENUM('s/p', 'c/p'),
    `descripcion_cardiovascular` JSON,
  `Pulsos` VARCHAR(255),
  `Inspeccion` VARCHAR(255),
  `Auscultacion_Cardiaca` VARCHAR(255),
  `Soplos` VARCHAR(255),
  `Extremidades` VARCHAR(255),
  `Pruebas_Especiales` VARCHAR(255),
     INDEX `fk_hco_cardio_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_cardio`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_Digestivo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_Digestivo` (
`id_hco_digestivo` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
    `digestivo` ENUM('s/p', 'c/p'),
   `descripcion_digestivo` JSON,
   `Cavidad_Oral` VARCHAR(255),
  `Abdomen_Inspeccion` VARCHAR(255),
    `Abdomen_Auscultacion` VARCHAR(255),
  `Abdomen_Palpacion_Superficial` VARCHAR(255),
  `Abdomen_Palpacion_Profunda` VARCHAR(255),
    `Maniobras_Especificas` VARCHAR(255),
  `Abdomen_Percusion` VARCHAR(255),
  `Region_Anal_y_Perianal` VARCHAR(255),
    INDEX `fk_hco_digestivo_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_digestivo`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_GenitoUrinario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_GenitoUrinario` (
`id_hco_genitourinario` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
    `genitourinario` ENUM('s/p', 'c/p'),
   `descripcion_genitourinario` JSON,
  `Evaluacion_Urinaria` VARCHAR(255),
  `Region_Renal` VARCHAR(255),
   `Region_Suprapubica` VARCHAR(255),
 `Genitales_Masculinos` VARCHAR(255),
  `Genitales_Femeninos_Externos` VARCHAR(255),
    `Factores_Relacionados` VARCHAR(255),
  `Antecedentes_Relevantes` VARCHAR(255),
    `Examenes_Especificos` VARCHAR(255),
    `Signos_y_Sintomas_Asociados` VARCHAR(255),
       INDEX `fk_hco_genitourinario_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_genitourinario`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_Osteomuscular`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_Osteomuscular` (
`id_hco_osteo` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
   `osteomuscular` ENUM('s/p', 'c/p'),
    `descripcion_osteomuscular` JSON,
  `Evaluacion_General` VARCHAR(255),
  `Columna_Vertebral` VARCHAR(255),
  `Evaluacion_Cervical` VARCHAR(255),
  `Miembros_Superiores` VARCHAR(255),
  `Miembros_Inferiores` VARCHAR(255),
  `Articulaciones` VARCHAR(255),
   `Evaluacion_Muscular` VARCHAR(255),
    `Pruebas_Funcionales` VARCHAR(255),
         INDEX `fk_hco_osteo_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_osteo`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_Endocrino`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_Endocrino` (
`id_hco_endocrino` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
   `endocrino` ENUM('s/p', 'c/p'),
   `descripcion_endocrino` JSON,
    `Evaluacion_Tiroides` VARCHAR(255),
  `Signos_y_Sintomas_Tiroideos` VARCHAR(255),
   `Paratiroides` VARCHAR(255),
  `Evaluacion_Hipofisis` VARCHAR(255),
   `Evaluacion_Suprarrenales` VARCHAR(255),
   `Caracteristicas_Sexuales_Secundarias` VARCHAR(255),
         INDEX `fk_hco_endocrino_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_endocrino`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_Hemolinfatico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_Hemolinfatico` (
`id_hco_hemolinfatico` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
   `hemolinfatico` ENUM('s/p', 'c/p'),
   `descripcion_hemolinfatico` JSON,
    `Evaluacion_Metabolica` VARCHAR(255),
  `Signos_de_Descompensacion` VARCHAR(255),
    `Sistema_Linfatico` VARCHAR(255),
 `Bazo` VARCHAR(255),
  `Higado_componente_hematologico` VARCHAR(255),
  `Manifestaciones_Hemorragicas` VARCHAR(255),
  `Manifestaciones_Sistemicas` VARCHAR(255),
  `Datos_Complementarios` VARCHAR(255),
  `Terapia_Actual` VARCHAR(255),
   `Laboratorio_Reciente` TEXT,
     INDEX `fk_hco_hemolinfatico_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_hemolinfatico`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_Nervioso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_Nervioso` (
`id_hco_nervioso` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
     `nervioso` ENUM('s/p', 'c/p'),
`descripcion_nervioso` JSON,
  `Evaluacion_Basica_Mental_y_Cognitiva` VARCHAR(255),
    `Evaluacion_Visual_Ocupacional` VARCHAR(255),
  `Evaluacion_Auditiva_Ocupacional` VARCHAR(255),
  `Evaluacion_Motora_Ocupacional` VARCHAR(255),
    `Coordinacion_Relacionada_al_Trabajo` VARCHAR(255),
    `Evaluacion_Postural_y_Marcha` VARCHAR(255),
  `Evaluacion_Sensitiva_Ocupacional` VARCHAR(255),
    `Signos_de_Riesgo_Ocupacional` VARCHAR(255),
 `Factores_de_Riesgo_Neurologico_Ocupacional` VARCHAR(255),
  `Sintomas_Relacionados_al_Trabajo` VARCHAR(255),
  `Analisis_Postural_Laboral` VARCHAR(255),
 `Factores_de_Riesgo_Biomecanico` VARCHAR(255),
   `Evaluacion_Columna_Cervical` VARCHAR(255),
  `Evaluacion_Miembros_Superiores` TEXT, -- Hombro
   `Codo` TEXT,
   `Muñeca_y_Mano` TEXT,
   `Evaluacion_Columna_Lumbar` VARCHAR(255),
  `Evaluacion_Miembros_Inferiores` VARCHAR(255),
  `Evaluacion_Funcional_Laboral` VARCHAR(255),
    `Sintomatologia_Osteomuscular` VARCHAR(255),
     INDEX `fk_hco_nervioso_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_nervioso`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_Ojos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_Ojos` (
`id_hco_ojos` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
  `ojos_parpados` ENUM('s/p', 'c/p'),
    `ojos_conjuntivas` ENUM('s/p', 'c/p'),
  `ojos_pupilas` ENUM('s/p', 'c/p'),
  `ojos_corneas` ENUM('s/p', 'c/p'),
  `ojos_motilidad` ENUM('s/p', 'c/p'),
  `ojos_descripcion` TEXT,
     INDEX `fk_hco_ojos_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_ojos`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_Oidos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_Oidos` (
`id_hco_oidos` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
  `oidos_cae` ENUM('s/p', 'c/p'),
    `oidos_pabellon` ENUM('s/p', 'c/p'),
   `oidos_timpano` ENUM('s/p', 'c/p'),
  `oidos_descripcion` TEXT,
     INDEX `fk_hco_oidos_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_oidos`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_Orofaringe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_Orofaringe` (
 `id_hco_orofaringe` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
  `orofaringe_labios` ENUM('s/p', 'c/p'),
    `orofaringe_lengua` ENUM('s/p', 'c/p'),
 `orofaringe_faringe` ENUM('s/p', 'c/p'),
  `orofaringe_amigdalas` ENUM('s/p', 'c/p'),
 `orofaringe_dentadura` ENUM('s/p', 'c/p'),
  `orofaringe_descripcion` TEXT,
    INDEX `fk_hco_orofaringe_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_orofaringe`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_Nariz`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_Nariz` (
`id_hco_nariz` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
  `nariz_tabique` ENUM('s/p', 'c/p'),
    `nariz_cornetes` ENUM('s/p', 'c/p'),
   `nariz_mucosas` ENUM('s/p', 'c/p'),
 `nariz_senos` ENUM('s/p', 'c/p'),
  `nariz_descripcion` TEXT,
   INDEX `fk_hco_nariz_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_nariz`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_Cuello`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_Cuello` (
`id_hco_cuello` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
   `cuello_tiroides` ENUM('s/p', 'c/p'),
    `cuello_movilidad` ENUM('s/p', 'c/p'),
  `cuello_descripcion` TEXT,
    INDEX `fk_hco_cuello_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_cuello`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_Torax`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_Torax` (
`id_hco_torax` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
`torax_mama` ENUM('s/p', 'c/p'),
    `torax_corazon` ENUM('s/p', 'c/p'),
  `torax_pulmones` ENUM('s/p', 'c/p'),
  `torax_parrilla` ENUM('s/p', 'c/p'),
 `torax_descripcion` TEXT,
     INDEX `fk_hco_torax_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_torax`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_Abdomen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_Abdomen` (
`id_hco_abdomen` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
   `abdomen_visceras` ENUM('s/p', 'c/p'),
 `abdomen_pared` ENUM('s/p', 'c/p'),
`abdomen_descripcion` TEXT,
    INDEX `fk_hco_abdomen_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_abdomen`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_Columna`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_Columna` (
`id_hco_columna` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
  `columna_flexibilidad` ENUM('s/p', 'c/p'),
   `columna_desviacion` ENUM('s/p', 'c/p'),
    `columna_dolor` ENUM('s/p', 'c/p'),
   `columna_descripcion` TEXT,
      INDEX `fk_hco_columna_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_columna`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_Pelvis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_Pelvis` (
`id_hco_pelvis` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
  `pelvis` ENUM('s/p', 'c/p'),
    `pelvis_genitales` ENUM('s/p', 'c/p'),
 `pelvis_descripcion` TEXT,
      INDEX `fk_hco_pelvis_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_pelvis`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `HistoriaClinica_Extremidades`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `HistoriaClinica_Extremidades` (
`id_hco_extremidades` INT AUTO_INCREMENT PRIMARY KEY,
    `id_hco` INT NOT NULL,
      `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_atencion` DATE NOT NULL,
  `extremidades_vascular` ENUM('s/p', 'c/p'),
   `extremidades_superior` ENUM('s/p', 'c/p'),
  `extremidades_inferior` ENUM('s/p', 'c/p'),
 `extremidades_descripcion` TEXT,
    INDEX `fk_hco_extremidades_idx` (`id_hco` ASC),
    CONSTRAINT `fk_hco_extremidades`
    FOREIGN KEY (`id_hco`)
    REFERENCES `t024_Historiaclinica` (`id_hco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t029_Resultados_examenes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t029_Resultados_examenes` (
    `id_resultado` VARCHAR(255) NOT NULL PRIMARY KEY,
    `id_empleado` VARCHAR(255) NOT NULL,
    `tipo_examen` TEXT,
    `fecha_examen` DATE NOT NULL,
    `resultado` VARCHAR(20),
    `resultado_descripcion` TEXT,
    `interpretacion` TEXT,
    `recomendaciones` TEXT,
    `archivo_resultado` LONGBLOB,
    INDEX `fk_resultados_empleados_idx` (`id_empleado` ASC),
    INDEX `fecha_examen_idx` (`fecha_examen` ASC),
    CONSTRAINT `fk_resultados_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t030_Diagnostico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t030_Diagnostico` (
    `id_diagnostico` VARCHAR(255) NOT NULL PRIMARY KEY,
    `id_empleado` VARCHAR(255) NOT NULL,
    `id_cie10` VARCHAR(255) NOT NULL,
    `tipo_diagnostico` ENUM('presuntivo', 'definitivo inicial', 'definitivo inicial confirmado con laboratorio', 'definitivo control') NOT NULL,
    `origen` ENUM('común', 'laboral') NOT NULL,
    `fecha_diagnostico` DATE NOT NULL,
    `estadistica` ENUM('caso nuevo', 'caso antiguo', 'en seguimiento') NOT NULL,
    INDEX `fk_diagnosticos_empleados_idx` (`id_empleado` ASC),
    INDEX `fk_diagnosticos_cie10_idx` (`id_cie10` ASC),
    CONSTRAINT `fk_diagnosticos_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
     CONSTRAINT `fk_diagnosticos_cie10`
    FOREIGN KEY (`id_cie10`)
    REFERENCES `t008_Cie10` (`id_cie10`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t031_Aptitud_medica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t031_Aptitud_medica` (
    `id_aptitud` VARCHAR(255) NOT NULL PRIMARY KEY,
    `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_evaluacion` DATE NOT NULL,
    `tipo_evaluacion` ENUM('ingreso', 'periódica', 'reintegro') NOT NULL,
    `resultado_aptitud` ENUM('apto', 'apto con limitaciones', 'apto en observación', 'no apto') NOT NULL,
     `observaciones` TEXT,
    `limitaciones` TEXT,
    `requiere_reubicacion` BOOLEAN,
    `id_medico` VARCHAR(255),
    `codigo_evaluacion` VARCHAR(255),
    INDEX `fk_aptitudmedica_empleados_idx` (`id_empleado` ASC),
    CONSTRAINT `fk_aptitudmedica_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
      CONSTRAINT `fk_aptitudmedica_medicos`
    FOREIGN KEY (`id_medico`)
    REFERENCES `t001_Usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t032_Aptitud_retiro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t032_Aptitud_retiro` (
    `id_aptitudretiro` VARCHAR(255) NOT NULL PRIMARY KEY,
    `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_evaluacion` DATE NOT NULL,
    `realizo_evaluacion_retiro` BOOLEAN,
`condicion_diagnostica` ENUM('presuntiva', 'definitiva', 'no aplica'),
`relacion_trabajo` ENUM('si', 'no', 'no aplica') NOT NULL,
`observaciones_retiro` TEXT,
    `id_medico` VARCHAR(255),
    `codigo_evaluacion` VARCHAR(255),
    INDEX `fk_aptitudretiro_empleados_idx` (`id_empleado` ASC),
    CONSTRAINT `fk_aptitudretiro_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
      CONSTRAINT `fk_aptitudretiro_medicos`
    FOREIGN KEY (`id_medico`)
    REFERENCES `t001_Usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t033_Recomendaciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t033_Recomendaciones` (
    `id_recomendaciones` VARCHAR(255) NOT NULL PRIMARY KEY,
    `id_empleado` VARCHAR(255) NOT NULL,
    `fecha_evaluacion` DATE NOT NULL,
`condicion_diagnostica` ENUM('presuntiva', 'definitiva', 'no aplica'),
`recomendaciones laborales` TEXT,
`recomendaciones generales` TEXT,
    `id_medico` VARCHAR(255),
    `codigo_evaluacion` VARCHAR(255),
    INDEX `fk_recomendaciones_empleados_idx` (`id_empleado` ASC),
    CONSTRAINT `fk_recomendaciones_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
      CONSTRAINT `fk_recomendaciones_medicos`
    FOREIGN KEY (`id_medico`)
    REFERENCES `t001_Usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t034_Tratamientos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t034_Tratamientos` (
    `id_tratamiento` INT AUTO_INCREMENT PRIMARY KEY,  -- Clave primaria autoincremental
    `id_empleado` INT NOT NULL,                       -- ID del empleado que prescribe
    `id_diagnostico` INT NOT NULL,                    -- ID del diagnóstico asociado
    `fecha_prescripcion` DATE NOT NULL,                -- Fecha de la prescripción
    `id_medicamento` INT NOT NULL,                    -- ID del medicamento
    `cantidad` VARCHAR(255) NOT NULL,                  -- Dosis del medicamento
    `cantidad_letras` TEXT NOT NULL,                  -- Dosis en palabras
    `frecuencia` TEXT NOT NULL,                       -- Frecuencia de la dosis
    `duracion` TEXT NOT NULL,                         -- Duración del tratamiento
    `dosis_manana` TEXT,                              -- Dosis en la mañana
    `dosis_mediodia` TEXT,                            -- Dosis en mediodía
    `dosis_tarde` TEXT,                               -- Dosis en la tarde
    `dosis_noche` TEXT,                               -- Dosis en la noche
    `instrucciones_especiales` TEXT,                  -- Instrucciones adicionales
    `archivo_receta` LONGBLOB,                        -- Archivo de la receta en binario (opcional)
    `estado` ENUM('activo', 'completado') NOT NULL,    -- Estado del tratamiento (activo o completado)
    INDEX `fk_tratamientos_empleados_idx` (`id_empleado`),
    INDEX `fk_tratamientos_vademecum_idx` (`id_medicamento`),
    INDEX `fk_tratamientos_diagnosticos_idx` (`id_diagnostico`),
    CONSTRAINT `fk_tratamientos_empleados`
        FOREIGN KEY (`id_empleado`)
        REFERENCES `t012_Empleados` (`id_empleado`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_tratamientos_vademecum`
        FOREIGN KEY (`id_medicamento`)
        REFERENCES `t009_Vademecum` (`id_medicamento`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_tratamientos_diagnosticos`
        FOREIGN KEY (`id_diagnostico`)
        REFERENCES `t030_Diagnostico` (`id_diagnostico`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t035_Certificados_reposos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t035_Certificados_reposos` (
    `id_reposo` VARCHAR(255) NOT NULL PRIMARY KEY,
    `id_empleado` VARCHAR(255) NOT NULL,
    `id_diagnostico` VARCHAR(255) NOT NULL,
    `fecha_emision` DATE NOT NULL,
    `tipo_contingencia` ENUM('enfermedad común', 'accidente trabajo', 'enfermedad profesional') NOT NULL,
    `sintomatologia` TEXT,
    `descripcion` TEXT,
    `dias_reposo` DECIMAL(10,2) NOT NULL,
    `fecha_inicio` DATE NOT NULL,
    `fecha_fin` DATE NOT NULL,
    `tipo_reposo` ENUM('total', 'parcial') NOT NULL,
    `horas_reposo` DECIMAL(10,2),
    `establecimiento` TEXT NOT NULL,
    `archivo_reposo` LONGBLOB,
    `estado` ENUM('activo', 'finalizado') NOT NULL,
     INDEX `fk_reposos_empleados_idx` (`id_empleado` ASC),
    INDEX `fk_reposos_diagnosticos_idx` (`id_diagnostico` ASC),
    CONSTRAINT `fk_reposos_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
     CONSTRAINT `fk_reposos_diagnosticos`
    FOREIGN KEY (`id_diagnostico`)
    REFERENCES `t030_Diagnostico` (`id_diagnostico`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t036_Carnet_vacunacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t036_Carnet_vacunacion` (
  `id_vacunacion` VARCHAR(255) NOT NULL PRIMARY KEY,    -- ID único de la vacunación
  `id_empleado` VARCHAR(255) NOT NULL,                  -- ID del empleado que recibió la vacuna
  `id_vacuna` VARCHAR(255) NOT NULL,                    -- ID de la vacuna (relacionada con `t038_VacunasDisponibles`)
  `tipo_vacuna` TEXT NOT NULL,                          -- Tipo de vacuna (e.g., "Vacuna contra la Influenza")
  `fecha_aplicacion` DATE NOT NULL,                     -- Fecha en la que se administró la vacuna
  `dosis` TEXT NOT NULL,                                -- Dosis de la vacuna aplicada (e.g., "1ra dosis", "2da dosis", etc.)
  `lote_vacuna` TEXT NOT NULL,                          -- Lote de la vacuna aplicada
  `establecimiento` TEXT,                               -- Establecimiento donde se administró la vacuna
  `proxima_dosis` DATE,                                 -- Fecha de la próxima dosis (si aplica)
  `observaciones` TEXT,                                 -- Observaciones sobre la vacunación
  INDEX `fk_vacunacion_empleados_idx` (`id_empleado` ASC),
  INDEX `fk_vacunacion_vacunas_idx` (`id_vacuna` ASC),  -- Índice para la relación con la tabla `t038_VacunasDisponibles`
  CONSTRAINT `fk_vacunacion_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vacunacion_vacunas`
    FOREIGN KEY (`id_vacuna`)
    REFERENCES `t038_VacunasDisponibles` (`id_vacuna`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t037_Factores_riesgos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `t037_Factores_riesgos` (
    `id_factor` VARCHAR(255) NOT NULL PRIMARY KEY,
    `tipo_factor` ENUM('espacio físico reducido', 'virus', 'postura mantenida', 'exposición a polvo', 'ruido', 'exposicón a solventes') NOT NULL,
    `nombre_riesgo` ENUM('físico', 'químico', 'biológico', 'ergonómico', 'psicosocial', 'de seguridad') NOT NULL,
    `descripcion_peligro` TEXT NOT NULL,
    `efecto_en_salud` TEXT NOT NULL,
    `epp_recomendado` TEXT NOT NULL,
    `evaluacion_recomendada` TEXT NOT NULL,
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `t038Vacunasdisponibles`
CREATE TABLE IF NOT EXISTS `t038_VacunasDisponibles` (
    `id_vacuna` VARCHAR(255) NOT NULL PRIMARY KEY,      -- ID único de la vacuna
    `nombre_vacuna` TEXT NOT NULL,                      -- Nombre de la vacuna (e.g., "Vacuna contra la Influenza")
    `tipo_vacuna` ENUM('inactiva', 'viva atenuada', 'subunidad', 'conjugada', 'toxoid') NOT NULL, -- Tipo de vacuna
    `numero_dosis` INT NOT NULL,                        -- Número total de dosis recomendadas
    `periodicidad` ENUM('una sola dosis', '2 dosis', '3 dosis', 'dosis periódicas') NOT NULL, -- Tipo de esquema de dosis
    `via_administracion` ENUM('vía oral', 'intra muscular', 'subcutánea', 'intranasal', 'intradérmica') NOT NULL, -- Forma de administración
    `edad_minima` INT NOT NULL,                         -- Edad mínima para la aplicación
    `edad_maxima` INT NOT NULL,                         -- Edad máxima para la aplicación
    `grupo_poblacional` TEXT NOT NULL                   -- Grupo poblacional al que va dirigida (e.g., niños, embarazadas, adultos mayores)
)
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `t039_Consultorios` (
  `id_consultorio` VARCHAR(255) NOT NULL PRIMARY KEY,
  `tipo` TEXT NOT NULL,
  `permiso_numero` TEXT NOT NULL,
  `numero_establecimiento` VARCHAR(20) UNIQUE,
  `unicodigo` VARCHAR(255) UNIQUE NOT NULL,
  `codigo` TEXT NOT NULL,
    `fecha_emision` DATE NOT NULL,
    `fecha_vencimiento` DATE NOT NULL,
  `id_ubicacion` INT,
  INDEX `fk_empresas_ubicaciones_idx` (`id_ubicacion` ASC),
  CONSTRAINT `fk_empresas_ubicaciones`
    FOREIGN KEY (`id_ubicacion`)
    REFERENCES `t011_Ciudades` (`id_ubicacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `InsumosBotiquin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `InsumosBotiquin` (
  `id_insumo` VARCHAR(255) NOT NULL PRIMARY KEY,
  `nombre_insumo` TEXT NOT NULL,
  `tipo_insumo` TEXT NOT NULL,
  `unidad_medida` TEXT NOT NULL,
  `stock_minimo` DECIMAL(10,2),
  `observaciones` TEXT
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `InspeccionBotiquin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `InspeccionBotiquin` (
  `id_inspeccion` VARCHAR(255) NOT NULL PRIMARY KEY,
  `id_botiquin` VARCHAR(255),
  `fecha_inspeccion` DATE NOT NULL,
  `hora_inspeccion` TIME NOT NULL,
  `ubicacion` TEXT NOT NULL,
  `estado_general` ENUM('óptimo', 'regular', 'deficiente') NOT NULL,
  `observaciones` TEXT,
  `acciones_requeridas` TEXT,
  `responsable_inspeccion` VARCHAR(255),
     CONSTRAINT `fk_inspeccion_botiquin_usuarios`
    FOREIGN KEY (`responsable_inspeccion`)
    REFERENCES `t001_Usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `UbicacionBotiquin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `UbicacionBotiquin` (
  `id_botiquin` VARCHAR(255) NOT NULL PRIMARY KEY,
   `id_sucursal` VARCHAR(255) ,
  `ubicacion_especifica` TEXT NOT NULL,
  `area_responsable` TEXT NOT NULL,
  `responsable_botiquin` VARCHAR(255),
   `observaciones` TEXT,
   CONSTRAINT `fk_ubicacion_botiquin_sucursales`
    FOREIGN KEY (`id_sucursal`)
    REFERENCES `t004_Sucursales` (`id_sucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_ubicacion_botiquin_usuarios`
    FOREIGN KEY (`responsable_botiquin`)
    REFERENCES `t001_Usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `InspeccionSSO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `InspeccionSSO` (
  `id_inspeccion` VARCHAR(255) NOT NULL PRIMARY KEY,
  `fecha_inspeccion` DATE NOT NULL,
  `id_sucursal` VARCHAR(255) ,
  `area_inspeccionada` TEXT NOT NULL,
  `tipo_inspeccion` TEXT NOT NULL,
   `hallazgos` TEXT NOT NULL,
  `nivel_riesgo` ENUM('alto', 'medio', 'bajo') NOT NULL,
  `acciones_correctivas` TEXT,
  `responsable_correccion` VARCHAR(255),
  `fecha_compromiso` DATE,
  `estado` ENUM('pendiente', 'en proceso', 'completado') NOT NULL,
   INDEX `fk_inspeccion_sso_sucursales_idx` (`id_sucursal` ASC),
      CONSTRAINT `fk_inspeccion_sso_sucursales`
    FOREIGN KEY (`id_sucursal`)
    REFERENCES `t004_Sucursales` (`id_sucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
     CONSTRAINT `fk_inspeccion_sso_usuarios`
    FOREIGN KEY (`responsable_correccion`)
    REFERENCES `t001_Usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `InvestigacionAT_EP`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `InvestigacionAT_EP` (
  `id_investigacion` VARCHAR(255) NOT NULL PRIMARY KEY,
  `tipo_evento` ENUM('accidente', 'enfermedad profesional') NOT NULL,
  `fecha_evento` DATE NOT NULL,
  `id_empleado` VARCHAR(255) NOT NULL,
  `lugar_evento` TEXT NOT NULL,
  `descripcion_evento` TEXT NOT NULL,
  `tipo_lesion` TEXT NOT NULL,
  `parte_afectada` TEXT NOT NULL,
  `dias_incapacidad` DECIMAL(10,2),
  `testigos` TEXT,
  `causas_inmediatas` TEXT NOT NULL,
  `causas_basicas` TEXT NOT NULL,
  `acciones_correctivas` TEXT NOT NULL,
  `responsable_acciones` VARCHAR(255),
  `fecha_seguimiento` DATE,
  `estado_investigacion` ENUM('en proceso', 'completada') NOT NULL,
  `documentos_respaldo` LONGBLOB,
   INDEX `fk_investigacion_at_ep_empleados_idx` (`id_empleado` ASC),
    CONSTRAINT `fk_investigacion_at_ep_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT `fk_investigacion_at_ep_usuarios`
    FOREIGN KEY (`responsable_acciones`)
    REFERENCES `t001_Usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `Capacitaciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Capacitaciones` (
  `id_capacitacion` VARCHAR(255) NOT NULL PRIMARY KEY,
  `tema` TEXT NOT NULL,
  `tipo_capacitacion` ENUM('seguridad', 'salud', 'primeros auxilios', 'otros') NOT NULL,
  `modalidad` ENUM('presencial', 'virtual', 'híbrida') NOT NULL,
  `fecha_inicio` DATE NOT NULL,
  `fecha_fin` DATE NOT NULL,
  `duracion_horas` DECIMAL(10,2) NOT NULL,
  `instructor` TEXT NOT NULL,
  `objetivo` TEXT NOT NULL,
  `contenido` TEXT NOT NULL,
  `materiales` TEXT,
  `cupo_maximo` DECIMAL(10,2),
  `estado` ENUM('programada', 'en curso', 'completada', 'cancelada') NOT NULL,
  `observaciones` TEXT
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `InscripcionCapacitacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `InscripcionCapacitacion` (
  `id_inscripcion` VARCHAR(255) NOT NULL PRIMARY KEY,
  `id_capacitacion` VARCHAR(255) NOT NULL,
  `id_empleado` VARCHAR(255) NOT NULL,
  `fecha_inscripcion` DATE NOT NULL,
  `asistencia` BOOLEAN,
  `calificacion` DECIMAL(10,2),
  `observaciones_participante` TEXT,
   `certificado_emitido` BOOLEAN,
    `fecha_certificado` DATE,
  `archivo_certificado` LONGBLOB,
   INDEX `fk_inscripcion_capacitacion_capacitaciones_idx` (`id_capacitacion` ASC),
    INDEX `fk_inscripcion_capacitacion_empleados_idx` (`id_empleado` ASC),
    CONSTRAINT `fk_inscripcion_capacitacion_capacitaciones`
    FOREIGN KEY (`id_capacitacion`)
    REFERENCES `Capacitaciones` (`id_capacitacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
      CONSTRAINT `fk_inscripcion_capacitacion_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `EvaluacionCapacitacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EvaluacionCapacitacion` (
  `id_evaluacion` VARCHAR(255) NOT NULL PRIMARY KEY,
  `id_capacitacion` VARCHAR(255) NOT NULL,
  `id_empleado` VARCHAR(255) NOT NULL,
  `fecha_evaluacion` DATE NOT NULL,
  `calificacion_contenido` DECIMAL(10,2) NOT NULL,
  `calificacion_instructor` DECIMAL(10,2) NOT NULL,
  `calificacion_materiales` DECIMAL(10,2) NOT NULL,
  `calificacion_organizacion` DECIMAL(10,2) NOT NULL,
  `comentarios` TEXT,
  `sugerencias` TEXT,
   INDEX `fk_evaluacion_capacitacion_capacitaciones_idx` (`id_capacitacion` ASC),
  INDEX `fk_evaluacion_capacitacion_empleados_idx` (`id_empleado` ASC),
    CONSTRAINT `fk_evaluacion_capacitacion_capacitaciones`
    FOREIGN KEY (`id_capacitacion`)
    REFERENCES `Capacitaciones` (`id_capacitacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
        CONSTRAINT `fk_evaluacion_capacitacion_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `Induccion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Induccion` (
`id_induccion` VARCHAR(255) NOT NULL PRIMARY KEY,
  `id_empleado` VARCHAR(255) NOT NULL,
  `fecha_induccion` DATE NOT NULL,
  `tipo_induccion` ENUM('general', 'específica', 'reinducción') NOT NULL,
  `temas_cubiertos` TEXT NOT NULL,
  `instructor` VARCHAR(255),
  `duracion_horas` DECIMAL(10,2) NOT NULL,
  `material_entregado` TEXT,
  `evaluacion_compresion` DECIMAL(10,2),
  `registro_firmas` LONGBLOB,
  `observaciones` TEXT,
  `estado` ENUM('completada', 'pendiente') NOT NULL,
   INDEX `fk_induccion_empleados_idx` (`id_empleado` ASC),
   CONSTRAINT `fk_induccion_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
CONSTRAINT `fk_induccion_usuarios`
    FOREIGN KEY (`instructor`)
    REFERENCES `t001_Usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `InformeAptitud`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `InformeAptitud` (
  `id_informeaptitud` VARCHAR(255) NOT NULL PRIMARY KEY,
  `id_empleado` VARCHAR(255) NOT NULL,
  `fecha_informeaptitud` DATE NOT NULL,
  `tipo_evaluacion` ENUM('ingreso', 'periódica', 'reintegro', 'retiro') NOT NULL,
  `puntuacion` DECIMAL(10,2),
    INDEX `fk_informe_aptitud_empleados_idx` (`id_empleado` ASC),
    CONSTRAINT `fk_informe_aptitud_empleados`
    FOREIGN KEY (`id_empleado`)
    REFERENCES `t012_Empleados` (`id_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;
-----------------------------------------
