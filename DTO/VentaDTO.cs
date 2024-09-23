using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO
{
    public class VentaDTO
    {
        [Key]
        public int VENTA_ID { get; set; }
        public DateTime FECHA { get; set; }
        public int CLIENTE_ID { get; set; }
        public string ESTATUS { get; set; }
        public int PRODUCTO_ID { get; set; }
        [Required]
        [Display(Name = "Cantidad")]
        public int CANTIDAD { get; set; }
        public decimal DESCUENTO { get; set; }
        public decimal TOTAL { get; set; }
    }
}
