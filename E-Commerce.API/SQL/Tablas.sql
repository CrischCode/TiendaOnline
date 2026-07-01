create table public.persona (
    id_persona uuid PRIMARY KEY,
    primer_nombre varchar(50) not null,
    segundo_nombre varchar(50),
    primer_apellido varchar(50) not null,
    segundo_apellido varchar(50),
    telefono varchar(20),
    fecha_nacimiento date,
    fecha_registro date,
    activo boolean default true,
);

create table public.cliente (
    id_cliente serial primary key,
    id_persona uuid not null unique
        references public.persona(id_persona) on delete cascade,
    fecha_alta date default now().(),
    puntos int default 0
);

create table public.empleado (
    id_empleado serial primary key,
    id_persona uuid not null unique
        references public.persona(id_persona) on delete cascade,
    fecha_ingreso date not null,
    activo boolean default true
);

create table public.salario (
    id_salario serial primary key,
    id_empleado int not null
        references public.empleado(id_empleado) on delete cascade,
    monto numeric(10,2) not null,
    fecha_inicio date not null,
    fecha_fin date
);

create table public.rol (
    id_rol serial primary key,
    nombre varchar(50) not null unique
);

create table public.persona_rol (
    id_persona uuid not null
        references public.persona(id_persona) on delete cascade,
    id_rol int not null
        references public.rol(id_rol) on delete cascade,
    primary key (id_persona, id_rol)
);

create table public.categoria (
id_categoria SERIAL primary key,
Nombre VARCHAR(100) not null unique,
Descripccion TEXT
);

CREATE TABLE public.subcategoria (
    id_subcategoria SERIAL PRIMARY KEY,
    id_categoria INT NOT NULL REFERENCES public.categoria(id_categoria) ON DELETE CASCADE,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

CREATE TABLE public.producto (
    id_producto SERIAL PRIMARY KEY,
    id_subcategoria INT NOT NULL REFERENCES public.subcategoria(id_subcategoria),
    sku VARCHAR(50) UNIQUE NOT NULL, 
    nombre VARCHAR(150) NOT NULL,
    descripcion_larga TEXT,
    descripcion_corta TEXT,
    especificaciones TEXT,
    precio_venta NUMERIC(18, 2) NOT NULL CHECK (precio_venta >= 0),
    stock_actual INT DEFAULT 0 CHECK (stock_actual >= 0),
    foto_url TEXT,
    foto_mimetype VARCHAR(50),
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT NOW()
);

create table public.pedido (
id_pedido SERIAL primary key,
id_cliente INT not null references public.cliente(id_cliente),
id_metodo_pago int references public.metodo_pago(id_metodo),
fecha_pedido timestamp default now(),
total numeric(18,2) not null,
estado VARCHAR(20) default 'Pendiente' check(estado in('Pendiente', 'En Proceso', 'Completado', 'Cancelado'))
);

create table public.detalle_pedido (
id_detalle_pedido serial primary key,
id_pedido int not null references public.pedido(id_pedido) on delete cascade,
id_producto int not null references public."Producto"("IdProducto"),
cantidad int not null,
precio_unitario numeric(18,2) not null,
sub_total numeric(12,2) generated always as (cantidad * precio_unitario) stored
);

create table public.movimiento_inventario(
id_movimiento serial primary key,
id_producto int not null references public."Producto"("IdProducto"),
tipo_movimiento varchar(20) not null,
cantidad int not null,
motivo varchar(100),
fecha_movimiento timestamp default now(),
id_empleado int references public.empleado(id_empleado)
);

create table public.pais(
id_pais serial primary key,
nombre varchar(50) not null unique
);

create table public.ciudad(
id_ciudad serial primary key,
id_pais int references public.pais(id_pais),
nombre varchar(50) not null
);

create table public.direccion(
id_direccion serial primary key ,
id_persona UUID not null references public.persona(id_persona),
id_pais int references public.pais(id_pais),
id_ciudad int references public.ciudad(id_ciudad),
calle_avenida varchar(100),
codigo_postal varchar(10),
es_principal boolean default false
);

create table public.metodo_pago(
id_metodo serial primary key,
nombre varchar(50) not null
);

create table public.proveedor (
    id_proveedor serial primary key,
    nombre_empresa varchar(100) not null,
    nit_rut varchar(20) unique,
    contacto_nombre varchar(100),
    telefono varchar(20)
);

create table public.carrito(
id_carrito serial primary key,
id_cliente int not null unique references public.cliente(id_cliente),
fecha_creacion timestamp default now(),
fecha_actualizacion timestamp
);

create table detalle_carrito(
id_detalleCarrito serial primary key,
id_carrito int references public.carrito(id_carrito) on delete cascade,
id_producto int not null references public."Producto"("IdProducto"),
cantidad int not null check (cantidad > 0)
);

--Pendiente
create table public.resena (
    id_resena serial primary key,
    id_producto int references public.producto(id_producto),
    id_cliente int references public.cliente(id_cliente),
    calificacion int check (calificacion between 1 and 5),
    comentario text,
    fecha_publicacion timestamp default now(),
    unique(id_producto, id_cliente) -- Una reseña por producto por cliente
);