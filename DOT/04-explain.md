
##########################################
# Specific connections and their reasons #
##########################################
----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between 0.0.0.0-255.255.255.255 => default/frontend[Deployment]:

Denied connections:
	Denied TCP, UDP, SCTP due to the following policies and rules:
		Egress (Allowed) due to the system default (Allow all)
		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but 0.0.0.0-255.255.255.255 is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], but 0.0.0.0-255.255.255.255 is not allowed by any Ingress rule


----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/adservice[Deployment] => default/frontend[Deployment]:

Denied connections:
	Denied TCP:[1-8079,8081-65535], UDP, SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/adservice-netpol' selects default/adservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/adservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/adservice[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Ingress rule #2 selects default/adservice[Deployment], but the protocols and ports do not match


	Denied TCP:[8080] due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/adservice-netpol' selects default/adservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/adservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)

		Ingress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Ingress rule #2

----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/cartservice[Deployment] => default/frontend[Deployment]:

Denied connections:
	Denied TCP:[1-8079,8081-65535], UDP:[1-5352,5354-65535], SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/cartservice-netpol' selects default/cartservice[Deployment], and Egress rule #2 selects default/frontend[Deployment], but the protocols and ports do not match
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/cartservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/cartservice[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Ingress rule #2 selects default/cartservice[Deployment], but the protocols and ports do not match


	Denied TCP:[8080] due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/cartservice-netpol' selects default/cartservice[Deployment], and Egress rule #2 selects default/frontend[Deployment], but the protocols and ports do not match
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/cartservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)

		Ingress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Ingress rule #2

	Denied UDP:[5353] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/cartservice-netpol' allows connections by Egress rule #2
		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/cartservice[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Ingress rule #2 selects default/cartservice[Deployment], but the protocols and ports do not match


----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/checkoutservice[Deployment] => default/frontend[Deployment]:

Denied connections:
	Denied TCP:[1-8079,8081-65535], UDP:[1-5352,5354-65535], SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/checkoutservice-netpol' selects default/checkoutservice[Deployment], and Egress rule #7 selects default/frontend[Deployment], but the protocols and ports do not match
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/checkoutservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/checkoutservice[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Ingress rule #2 selects default/checkoutservice[Deployment], but the protocols and ports do not match


	Denied TCP:[8080] due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/checkoutservice-netpol' selects default/checkoutservice[Deployment], and Egress rule #7 selects default/frontend[Deployment], but the protocols and ports do not match
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/checkoutservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)

		Ingress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Ingress rule #2

	Denied UDP:[5353] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/checkoutservice-netpol' allows connections by Egress rule #7
		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/checkoutservice[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Ingress rule #2 selects default/checkoutservice[Deployment], but the protocols and ports do not match


----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/currencyservice[Deployment] => default/frontend[Deployment]:

Denied connections:
	Denied TCP:[1-8079,8081-65535], UDP, SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/currencyservice-netpol' selects default/currencyservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/currencyservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/currencyservice[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Ingress rule #2 selects default/currencyservice[Deployment], but the protocols and ports do not match


	Denied TCP:[8080] due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/currencyservice-netpol' selects default/currencyservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/currencyservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)

		Ingress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Ingress rule #2

----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/emailservice[Deployment] => default/frontend[Deployment]:

Denied connections:
	Denied TCP:[1-8079,8081-65535], UDP, SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/emailservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/emailservice-netpol' selects default/emailservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/emailservice[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Ingress rule #2 selects default/emailservice[Deployment], but the protocols and ports do not match


	Denied TCP:[8080] due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/emailservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/emailservice-netpol' selects default/emailservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)

		Ingress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Ingress rule #2

----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/frontend[Deployment] => 0.0.0.0-255.255.255.255:

Denied connections:
	Denied TCP, UDP, SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but 0.0.0.0-255.255.255.255 is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], but 0.0.0.0-255.255.255.255 is not allowed by any Egress rule

		Ingress (Allowed) due to the system default (Allow all)

----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/frontend[Deployment] => default/adservice[Deployment]:

Allowed connections:
	Allowed TCP:[9555] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Egress rule #1
		Ingress (Allowed)
			NetworkPolicy 'default/adservice-netpol' allows connections by Ingress rule #1

Denied connections:
	Denied TCP:[1-9554,9556-65535], UDP:[1-5352,5354-65535], SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/adservice[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Egress rule #1 selects default/adservice[Deployment], but the protocols and ports do not match

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/adservice-netpol' selects default/adservice[Deployment], and Ingress rule #1 selects default/frontend[Deployment], but the protocols and ports do not match
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/adservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)


	Denied UDP:[5353] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Egress rule #8
		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/adservice-netpol' selects default/adservice[Deployment], and Ingress rule #1 selects default/frontend[Deployment], but the protocols and ports do not match
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/adservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)


----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/frontend[Deployment] => default/cartservice[Deployment]:

Allowed connections:
	Allowed TCP:[7070] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Egress rule #2
		Ingress (Allowed)
			NetworkPolicy 'default/cartservice-netpol' allows connections by Ingress rule #2

Denied connections:
	Denied TCP:[1-7069,7071-65535], UDP:[1-5352,5354-65535], SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/cartservice[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Egress rule #2 selects default/cartservice[Deployment], but the protocols and ports do not match

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/cartservice-netpol' selects default/cartservice[Deployment], and Ingress rule #2 selects default/frontend[Deployment], but the protocols and ports do not match
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/cartservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)


	Denied UDP:[5353] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Egress rule #8
		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/cartservice-netpol' selects default/cartservice[Deployment], and Ingress rule #2 selects default/frontend[Deployment], but the protocols and ports do not match
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/cartservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)


----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/frontend[Deployment] => default/checkoutservice[Deployment]:

Allowed connections:
	Allowed TCP:[5050] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Egress rule #3
		Ingress (Allowed)
			NetworkPolicy 'default/checkoutservice-netpol' allows connections by Ingress rule #1

Denied connections:
	Denied TCP:[1-5049,5051-65535], UDP:[1-5352,5354-65535], SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/checkoutservice[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Egress rule #3 selects default/checkoutservice[Deployment], but the protocols and ports do not match

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/checkoutservice-netpol' selects default/checkoutservice[Deployment], and Ingress rule #1 selects default/frontend[Deployment], but the protocols and ports do not match
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/checkoutservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)


	Denied UDP:[5353] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Egress rule #8
		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/checkoutservice-netpol' selects default/checkoutservice[Deployment], and Ingress rule #1 selects default/frontend[Deployment], but the protocols and ports do not match
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/checkoutservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)


----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/frontend[Deployment] => default/currencyservice[Deployment]:

Allowed connections:
	Allowed TCP:[7000] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Egress rule #4
		Ingress (Allowed)
			NetworkPolicy 'default/currencyservice-netpol' allows connections by Ingress rule #2

Denied connections:
	Denied TCP:[1-6999,7001-65535], UDP:[1-5352,5354-65535], SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/currencyservice[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Egress rule #4 selects default/currencyservice[Deployment], but the protocols and ports do not match

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/currencyservice-netpol' selects default/currencyservice[Deployment], and Ingress rule #2 selects default/frontend[Deployment], but the protocols and ports do not match
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/currencyservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)


	Denied UDP:[5353] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Egress rule #8
		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/currencyservice-netpol' selects default/currencyservice[Deployment], and Ingress rule #2 selects default/frontend[Deployment], but the protocols and ports do not match
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/currencyservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)


----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/frontend[Deployment] => default/emailservice[Deployment]:

Denied connections:
	Denied TCP, UDP:[1-5352,5354-65535], SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/emailservice[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Egress rule #8 selects default/emailservice[Deployment], but the protocols and ports do not match

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/emailservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/emailservice-netpol' selects default/emailservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule


	Denied UDP:[5353] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Egress rule #8
		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/emailservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/emailservice-netpol' selects default/emailservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule


----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/frontend[Deployment] => default/loadgenerator[Deployment]:

Denied connections:
	Denied TCP, UDP:[1-5352,5354-65535], SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/loadgenerator[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Egress rule #8 selects default/loadgenerator[Deployment], but the protocols and ports do not match

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/loadgenerator[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/loadgenerator-netpol' selects default/loadgenerator[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)


	Denied UDP:[5353] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Egress rule #8
		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/loadgenerator[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/loadgenerator-netpol' selects default/loadgenerator[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)


----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/frontend[Deployment] => default/paymentservice[Deployment]:

Denied connections:
	Denied TCP, UDP:[1-5352,5354-65535], SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/paymentservice[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Egress rule #8 selects default/paymentservice[Deployment], but the protocols and ports do not match

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/paymentservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/paymentservice-netpol' selects default/paymentservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule


	Denied UDP:[5353] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Egress rule #8
		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/paymentservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/paymentservice-netpol' selects default/paymentservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule


----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/frontend[Deployment] => default/productcatalogservice[Deployment]:

Allowed connections:
	Allowed TCP:[3550] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Egress rule #6
		Ingress (Allowed)
			NetworkPolicy 'default/productcatalogservice-netpol' allows connections by Ingress rule #2

Denied connections:
	Denied TCP:[1-3549,3551-65535], UDP:[1-5352,5354-65535], SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/productcatalogservice[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Egress rule #6 selects default/productcatalogservice[Deployment], but the protocols and ports do not match

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/productcatalogservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/productcatalogservice-netpol' selects default/productcatalogservice[Deployment], and Ingress rule #2 selects default/frontend[Deployment], but the protocols and ports do not match


	Denied UDP:[5353] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Egress rule #8
		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/productcatalogservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/productcatalogservice-netpol' selects default/productcatalogservice[Deployment], and Ingress rule #2 selects default/frontend[Deployment], but the protocols and ports do not match


----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/frontend[Deployment] => default/recommendationservice[Deployment]:

Allowed connections:
	Allowed TCP:[8080] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Egress rule #7
		Ingress (Allowed)
			NetworkPolicy 'default/recommendationservice-netpol' allows connections by Ingress rule #1

Denied connections:
	Denied TCP:[1-8079,8081-65535], UDP:[1-5352,5354-65535], SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/recommendationservice[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Egress rule #7 selects default/recommendationservice[Deployment], but the protocols and ports do not match

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/recommendationservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/recommendationservice-netpol' selects default/recommendationservice[Deployment], and Ingress rule #1 selects default/frontend[Deployment], but the protocols and ports do not match


	Denied UDP:[5353] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Egress rule #8
		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/recommendationservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/recommendationservice-netpol' selects default/recommendationservice[Deployment], and Ingress rule #1 selects default/frontend[Deployment], but the protocols and ports do not match


----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/frontend[Deployment] => default/redis-cart[Deployment]:

Denied connections:
	Denied TCP, UDP:[1-5352,5354-65535], SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/redis-cart[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Egress rule #8 selects default/redis-cart[Deployment], but the protocols and ports do not match

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/redis-cart[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/redis-cart-netpol' selects default/redis-cart[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule


	Denied UDP:[5353] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Egress rule #8
		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/redis-cart[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/redis-cart-netpol' selects default/redis-cart[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule


----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/frontend[Deployment] => default/shippingservice[Deployment]:

Allowed connections:
	Allowed TCP:[50051] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Egress rule #5
		Ingress (Allowed)
			NetworkPolicy 'default/shippingservice-netpol' allows connections by Ingress rule #2

Denied connections:
	Denied TCP:[1-50050,50052-65535], UDP:[1-5352,5354-65535], SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/shippingservice[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Egress rule #5 selects default/shippingservice[Deployment], but the protocols and ports do not match

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/shippingservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/shippingservice-netpol' selects default/shippingservice[Deployment], and Ingress rule #2 selects default/frontend[Deployment], but the protocols and ports do not match


	Denied UDP:[5353] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Egress rule #8
		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/shippingservice[Deployment], but default/frontend[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/shippingservice-netpol' selects default/shippingservice[Deployment], and Ingress rule #2 selects default/frontend[Deployment], but the protocols and ports do not match


----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/loadgenerator[Deployment] => default/frontend[Deployment]:

Allowed connections:
	Allowed TCP:[8080] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/loadgenerator-netpol' allows connections by Egress rule #1
		Ingress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Ingress rule #1

Denied connections:
	Denied TCP:[1-8079,8081-65535], UDP:[1-5352,5354-65535], SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/loadgenerator[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/loadgenerator-netpol' selects default/loadgenerator[Deployment], and Egress rule #1 selects default/frontend[Deployment], but the protocols and ports do not match

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/loadgenerator[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Ingress rule #1 selects default/loadgenerator[Deployment], but the protocols and ports do not match


	Denied UDP:[5353] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/loadgenerator-netpol' allows connections by Egress rule #2
		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/loadgenerator[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Ingress rule #1 selects default/loadgenerator[Deployment], but the protocols and ports do not match


----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/paymentservice[Deployment] => default/frontend[Deployment]:

Denied connections:
	Denied TCP:[1-8079,8081-65535], UDP, SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/paymentservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/paymentservice-netpol' selects default/paymentservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/paymentservice[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Ingress rule #2 selects default/paymentservice[Deployment], but the protocols and ports do not match


	Denied TCP:[8080] due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/paymentservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/paymentservice-netpol' selects default/paymentservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)

		Ingress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Ingress rule #2

----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/productcatalogservice[Deployment] => default/frontend[Deployment]:

Denied connections:
	Denied TCP:[1-8079,8081-65535], UDP, SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/productcatalogservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/productcatalogservice-netpol' selects default/productcatalogservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/productcatalogservice[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Ingress rule #2 selects default/productcatalogservice[Deployment], but the protocols and ports do not match


	Denied TCP:[8080] due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/productcatalogservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/productcatalogservice-netpol' selects default/productcatalogservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)

		Ingress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Ingress rule #2

----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/recommendationservice[Deployment] => default/frontend[Deployment]:

Denied connections:
	Denied TCP:[1-8079,8081-65535], UDP:[1-5352,5354-65535], SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/recommendationservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/recommendationservice-netpol' selects default/recommendationservice[Deployment], and Egress rule #2 selects default/frontend[Deployment], but the protocols and ports do not match

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/recommendationservice[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Ingress rule #2 selects default/recommendationservice[Deployment], but the protocols and ports do not match


	Denied TCP:[8080] due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/recommendationservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/recommendationservice-netpol' selects default/recommendationservice[Deployment], and Egress rule #2 selects default/frontend[Deployment], but the protocols and ports do not match

		Ingress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Ingress rule #2

	Denied UDP:[5353] due to the following policies and rules:
		Egress (Allowed)
			NetworkPolicy 'default/recommendationservice-netpol' allows connections by Egress rule #2
		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/recommendationservice[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Ingress rule #2 selects default/recommendationservice[Deployment], but the protocols and ports do not match


----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/redis-cart[Deployment] => default/frontend[Deployment]:

Denied connections:
	Denied TCP:[1-8079,8081-65535], UDP, SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/redis-cart[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/redis-cart-netpol' selects default/redis-cart[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/redis-cart[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Ingress rule #2 selects default/redis-cart[Deployment], but the protocols and ports do not match


	Denied TCP:[8080] due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/redis-cart[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/redis-cart-netpol' selects default/redis-cart[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)

		Ingress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Ingress rule #2

----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between default/shippingservice[Deployment] => default/frontend[Deployment]:

Denied connections:
	Denied TCP:[1-8079,8081-65535], UDP, SCTP due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/shippingservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/shippingservice-netpol' selects default/shippingservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)

		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but default/shippingservice[Deployment] is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Ingress rule #2 selects default/shippingservice[Deployment], but the protocols and ports do not match


	Denied TCP:[8080] due to the following policies and rules:
		Egress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/shippingservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)
				- NetworkPolicy 'default/shippingservice-netpol' selects default/shippingservice[Deployment], but default/frontend[Deployment] is not allowed by any Egress rule (no rules defined)

		Ingress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Ingress rule #2

----------------------------------------------------------------------------------------------------------------------------------------------------------------
Connections between {ingress-controller} => default/frontend[Deployment]:

Allowed connections:
	Allowed TCP:[8080] due to the following policies and rules:
		Egress (Allowed) due to the system default (Allow all)
		Ingress (Allowed)
			NetworkPolicy 'default/frontend-netpol' allows connections by Ingress rule #2
			Route 'default/frontend' allows ingress connections through service frontend

Denied connections:
	Denied TCP:[1-8079,8081-65535], UDP, SCTP due to the following policies and rules:
		Egress (Allowed) due to the system default (Allow all)
		Ingress (Denied)
			NetworkPolicy list:
				- NetworkPolicy 'default/default-deny-in-namespace' selects default/frontend[Deployment], but {ingress-controller} is not allowed by any Ingress rule (no rules defined)
				- NetworkPolicy 'default/frontend-netpol' selects default/frontend[Deployment], and Ingress rule #2 selects {ingress-controller}, but the protocols and ports do not match

			Route 'default/frontend' allows ingress to service frontend, but the protocols and ports do not match


