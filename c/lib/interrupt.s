        .export _nmi_handler
        .export _irq_handler
        .export _irq_init

        .code

_irq_init:
        rts

_nmi_handler:
        rti
        
_irq_handler:
        rti