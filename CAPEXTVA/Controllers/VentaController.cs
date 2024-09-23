using CAPEXTVA.Models;
using DTO;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Reflection.Emit;
using System.Web;
using System.Web.Mvc;

namespace CAPEXTVA.Controllers
{
    public class VentaController : Controller
    {
        // GET: Venta
        public ActionResult Index()
        {
            cargarDDL();
            using (CAPEXTVAEntities1 context = new CAPEXTVAEntities1())
            {
                var listaVentas = context.VISTA_VENTAS_CLIENTES.ToList();
                ViewBag.Ventas = listaVentas;
                return View();
            }
        }

        public int Guardar(VentaDTO model)
        {
            using (CAPEXTVAEntities1 context = new CAPEXTVAEntities1())
            {
                var venta = new VENTA();

                venta.FECHA = DateTime.Now;
                venta.CLIENTE_ID = model.CLIENTE_ID;
                venta.ESTATUS = "ACTIVO";

                var detalle = new DETALLE_VENTA();

                detalle.PRODUCTO_ID = model.PRODUCTO_ID;
                detalle.CANTIDAD = model.CANTIDAD;
                detalle.DESCUENTO = 0;

                var producto = context.PRODUCTO.Find(model.PRODUCTO_ID);
                detalle.TOTAL = producto.COSTO_UNITARIO * model.CANTIDAD;

                context.VENTA.Add(venta);
                context.DETALLE_VENTA.Add(detalle);

                context.SaveChanges();
            }

            return 1;
        }


        [HttpPost]
        public ActionResult NuevaVenta(VentaDTO model)
        {
            int resultado = 0;
            resultado = Guardar(model);
            return RedirectToAction("Index");
        }

        public void cargarDDL()
        {
            using (CAPEXTVAEntities1 context = new CAPEXTVAEntities1())
            {
                var clientes = context.CLIENTE.ToList();
                ViewBag.ListaClientes = clientes;

                var productos = context.PRODUCTO.Where(p => p.ESTATUS == "ACTIVO").ToList();
                ViewBag.ListaProductos = productos;
            }
        }
    }
}