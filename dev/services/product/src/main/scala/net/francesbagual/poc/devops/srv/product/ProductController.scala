package net.francesbagual.poc.devops.srv.product

import com.twitter.finagle.http.Request
import com.twitter.finatra.http.Controller

class ProductController extends Controller {

  get("/hi") {request:Request => 
    info("hi")
    "hello " + request.params.getOrElse("name", "unamed")
  }

}
