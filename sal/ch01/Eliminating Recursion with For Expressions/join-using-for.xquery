xquery version "1.0";
for $cust in doc('customer.xml')/*/customer return
     ($cust/id/text(), sum (for $ord in doc('orders.xml')/*/order[custID eq $cust/id]
              return ($ord/total)))

