# Frontend Connectivity Analysis

## Connections from Frontend 

| Destination | Allowed | Denied | Policy Reference |
|-------------|---------|--------|------------------|
| **adservice** | TCP 9555 | TCP 1-9554,9556-65535<br/>UDP 1-5352,5354-65535<br/>UDP 5353<br/>SCTP | **Allowed:** `frontend-netpol` Egress rule #1, `adservice-netpol` Ingress rule #1<br/>**Denied UDP 5353:** Egress allowed by `frontend-netpol` rule #8, but Ingress denied |
| **cartservice** | TCP 7070 | TCP 1-7069,7071-65535<br/>UDP 1-5352,5354-65535<br/>UDP 5353<br/>SCTP | **Allowed:** `frontend-netpol` Egress rule #2, `cartservice-netpol` Ingress rule #2<br/>**Denied UDP 5353:** Egress allowed by `frontend-netpol` rule #8, but Ingress denied |
| **checkoutservice** | TCP 5050 | TCP 1-5049,5051-65535<br/>UDP 1-5352,5354-65535<br/>UDP 5353<br/>SCTP | **Allowed:** `frontend-netpol` Egress rule #3, `checkoutservice-netpol` Ingress rule #8<br/>**Denied UDP 5353:** Egress allowed by `frontend-netpol` rule #8, but Ingress denied |
| **currencyservice** | TCP 7000 | TCP 1-6999,7001-65535<br/>UDP 1-5352,5354-65535<br/>UDP 5353<br/>SCTP | **Allowed:** `frontend-netpol` Egress rule #4, `currencyservice-netpol` Ingress rule #1<br/>**Denied UDP 5353:** Egress allowed by `frontend-netpol` rule #8, but Ingress denied |
| **productcatalogservice** | TCP 3550 | TCP 1-3549,3551-65535<br/>UDP 1-5352,5354-65535<br/>UDP 5353<br/>SCTP | **Allowed:** `frontend-netpol` Egress rule #5, `productcatalogservice-netpol` Ingress rule #1<br/>**Denied UDP 5353:** Egress allowed by `frontend-netpol` rule #8, but Ingress denied |
| **recommendationservice** | TCP 8080 | TCP 1-8079,8081-65535<br/>UDP 1-5352,5354-65535<br/>UDP 5353<br/>SCTP | **Allowed:** `frontend-netpol` Egress rule #6, `recommendationservice-netpol` Ingress rule #1<br/>**Denied UDP 5353:** Egress allowed by `frontend-netpol` rule #8, but Ingress denied |
| **shippingservice** | TCP 50051 | TCP 1-50050,50052-65535<br/>UDP 1-5352,5354-65535<br/>UDP 5353<br/>SCTP | **Allowed:** `frontend-netpol` Egress rule #7, `shippingservice-netpol` Ingress rule #2<br/>**Denied UDP 5353:** Egress allowed by `frontend-netpol` rule #8, but Ingress denied |
| emailservice | None | TCP (all)<br/>UDP 1-5352,5354-65535<br/>UDP 5353<br/>SCTP | **Egress denied:** No rule in `frontend-netpol`<br/>**UDP 5353:** Egress allowed by `frontend-netpol` rule #8, but Ingress denied |
| loadgenerator | None | TCP (all)<br/>UDP 1-5352,5354-65535<br/>UDP 5353<br/>SCTP | **Egress denied:** No rule in `frontend-netpol`<br/>**UDP 5353:** Egress allowed by `frontend-netpol` rule #8, but Ingress denied |
| paymentservice | None | TCP (all)<br/>UDP 1-5352,5354-65535<br/>UDP 5353<br/>SCTP | **Egress denied:** No rule in `frontend-netpol`<br/>**UDP 5353:** Egress allowed by `frontend-netpol` rule #8, but Ingress denied |
| redis-cart | None | TCP (all)<br/>UDP 1-5352,5354-65535<br/>UDP 5353<br/>SCTP | **Egress denied:** No rule in `frontend-netpol`<br/>**UDP 5353:** Egress allowed by `frontend-netpol` rule #8, but Ingress denied |
| **0.0.0.0/0** | None | TCP, UDP, SCTP (all) | **Egress denied:** Not allowed by any rule in `frontend-netpol` or `default-deny-in-namespace` |

---

## Connections to Frontend 

| Source | Allowed | Denied | Policy Reference |
|--------|---------|--------|------------------|
| **loadgenerator** | TCP 8080 | TCP 1-8079,8081-65535<br/>UDP 1-5352,5354-65535<br/>UDP 5353<br/>SCTP | **Allowed:** `loadgenerator-netpol` Egress rule #1, `frontend-netpol` Ingress rule #1<br/>**Denied UDP 5353:** Egress allowed by `loadgenerator-netpol` rule #2, but Ingress denied |
| **ingress-controller** | TCP 8080 | TCP 1-8079,8081-65535<br/>UDP, SCTP (all) | **Allowed:** System default Egress (allow all), `frontend-netpol` Ingress rule #2, Route 'frontend' |
| adservice | None | TCP 1-8079,8081-65535<br/>TCP 8080<br/>UDP, SCTP (all) | **TCP 8080:** Egress denied (no rule in `adservice-netpol`), but Ingress allowed by `frontend-netpol` rule #2<br/>**Other:** Egress and Ingress both deny |
| cartservice | None | TCP 1-8079,8081-65535<br/>TCP 8080<br/>UDP 1-5352,5354-65535<br/>UDP 5353<br/>SCTP | **TCP 8080:** Egress denied, but Ingress allowed by `frontend-netpol` rule #2<br/>**UDP 5353:** Egress allowed by `cartservice-netpol` rule #2, but Ingress denied<br/>**Other:** Egress and Ingress both deny |
| checkoutservice | None | TCP 1-8079,8081-65535<br/>TCP 8080<br/>UDP 1-5352,5354-65535<br/>UDP 5353<br/>SCTP | **TCP 8080:** Egress denied, but Ingress allowed by `frontend-netpol` rule #2<br/>**UDP 5353:** Egress allowed by `checkoutservice-netpol` rule #7, but Ingress denied<br/>**Other:** Egress and Ingress both deny |
| currencyservice | None | TCP 1-8079,8081-65535<br/>TCP 8080<br/>UDP, SCTP (all) | **TCP 8080:** Egress denied (no rule), but Ingress allowed by `frontend-netpol` rule #2<br/>**Other:** Egress and Ingress both deny |
| emailservice | None | TCP 1-8079,8081-65535<br/>TCP 8080<br/>UDP, SCTP (all) | **TCP 8080:** Egress denied (no rule), but Ingress allowed by `frontend-netpol` rule #2<br/>**Other:** Egress and Ingress both deny |
| paymentservice | None | TCP 1-8079,8081-65535<br/>TCP 8080<br/>UDP, SCTP (all) | **TCP 8080:** Egress denied (no rule), but Ingress allowed by `frontend-netpol` rule #2<br/>**Other:** Egress and Ingress both deny |
| productcatalogservice | None | TCP 1-8079,8081-65535<br/>TCP 8080<br/>UDP, SCTP (all) | **TCP 8080:** Egress denied (no rule), but Ingress allowed by `frontend-netpol` rule #2<br/>**Other:** Egress and Ingress both deny |
| recommendationservice | None | TCP 1-8079,8081-65535<br/>TCP 8080<br/>UDP, SCTP (all) | **TCP 8080:** Egress denied (no rule), but Ingress allowed by `frontend-netpol` rule #2<br/>**Other:** Egress and Ingress both deny |
| redis-cart | None | TCP 1-8079,8081-65535<br/>TCP 8080<br/>UDP, SCTP (all) | **TCP 8080:** Egress denied (no rule), but Ingress allowed by `frontend-netpol` rule #2<br/>**Other:** Egress and Ingress both deny |
| shippingservice | None | TCP 1-8079,8081-65535<br/>TCP 8080<br/>UDP, SCTP (all) | **TCP 8080:** Egress denied (no rule), but Ingress allowed by `frontend-netpol` rule #2<br/>**Other:** Egress and Ingress both deny |
| **0.0.0.0/0** | None | TCP, UDP, SCTP (all) | **Egress:** System default (allow all)<br/>**Ingress denied:** Not allowed by any rule in `default-deny-in-namespace` or `frontend-netpol` |
