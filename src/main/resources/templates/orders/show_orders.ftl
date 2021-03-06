<html>
<head>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/css/bootstrap-datepicker.standalone.min.css"
          rel="stylesheet"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.4/js/bootstrap-datepicker.min.js"></script>
    <title>${headline}</title>
    <style>
        .orders {
            font-size: large;
            overflow-x: hidden;
        }

        .resolved {
            color: green;
        }

        .cancelled {
            color: red;
        }

        .pending {
            color: steelblue;
        }
    </style>
    <script>
        $(document).ready(function () {
            $('.datepicker').datepicker({
                format: 'yyyy-mm-dd',
                todayHighlight: true
            });
        })
    </script>
</head>
<body>
<div class="row bg-dark">
    <div class="ml-4">
        <a href="/" class="btn btn-primary m-4">Main page</a>
    </div>

    <div class="m-3 rounded bg-white mx-auto">
        <form class="form-inline pt-3" method="GET" action="${exportUrl}">
            <div class="input-group date mx-2">
                <label for="start-date-picker" class="font-weight-bold mx-1">Start date:</label>
                <input type="text" class="form-control datepicker" id="start-date-picker"
                       name="startDate" value="${exportDates.startDate}">
            </div>
            <div class="input-group date mx-2">
                <label for="end-date-picker" class="font-weight-bold mx-1">End date:</label>
                <input type="text" class="form-control datepicker" id="end-date-picker"
                       name="endDate" value="${exportDates.endDate}">
            </div>
            <button class="btn btn-success mx-2" type="submit">Export to excel</button>
        </form>
    </div>
    <div class="ml-auto mr-4">
        <a href="/orders/new" class="btn btn-success m-4">New + </a>
    </div>
</div>

<div class="container mt-3 bg-light p-3">
    <h2 class="m-a bg-white p-3 rounded text-center">
        ${headline}
    </h2>
</div>

<div class="container orders mt-5">

    <div class="nav nav-tabs nav-fill" id="nav-tab" role="tablist">
        <a class="nav-item nav-link <#if currentState == 'PENDING'>active</#if>" href="?state=PENDING">Pending</a>
        <a class="nav-item nav-link <#if currentState == 'RESOLVED'>active</#if>" href="?state=RESOLVED">Resolved</a>
        <a class="nav-item nav-link <#if currentState == 'CANCELLED'>active</#if>" href="?state=CANCELLED">Cancelled</a>
    </div>

    <#if orders.content?size == 0>
        <h1 class="text-center jumbotron">List is empty!</h1>
    </#if>

    <div class="orders">
        <#list orders.content as order>
            <div class="row my-3 p-4 bg-light">
                <div class="col-md-10 row">
                    <div class="col-md-4">
                        <div class="p-4 rounded bg-white">
                            <div class="row">
                                <strong>#${order.orderId} ${order.productName}</strong>
                            </div>
                        </div>
                        <div class="mt-4 px-4 py-2 rounded bg-white">
                            <div class="px-2 rounded bg-white mx-3 ${order.state} font-weight-bold text-center">
                                ${order.state}
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="row">
                            Client:
                            <div class="px-2 rounded bg-white mx-3">
                                <strong>${order.clientFirstName} ${order.clientLastName}</strong>
                            </div>
                        </div>
                        <div class="row">
                            Client email:
                            <div class="px-2 rounded bg-white mx-3">
                                <strong>${order.clientEmail}</strong>
                            </div>
                        </div>
                        <div class="row">
                            Item price:
                            <div class="px-2 rounded bg-white mx-3">
                                <strong>${order.itemPrice}</strong>
                            </div>
                        </div>
                        <div class="row">
                            Items amount:
                            <div class="px-2 rounded bg-white mx-3">
                                <strong>${order.productOrderAmount}</strong>
                            </div>
                        </div>
                        <div class="row">
                            Total price:
                            <div class="px-2 rounded bg-white mx-3">
                                <strong>${order.totalPrice}</strong>
                            </div>
                        </div>
                        <div class="row">
                            Order created time:
                            <div class="px-2 rounded bg-white mx-3">
                                <strong>${order.createdDateTime}</strong>
                            </div>
                        </div>
                        <#if order.createdDateTime != order.updatedDateTime>
                            <div class="row">
                                Order state updated time:
                                <div class="px-2 rounded bg-white mx-3">
                                    <strong>${order.updatedDateTime}</strong>
                                </div>
                            </div>
                        </#if>
                    </div>
                </div>
                <div class="col-md-2 d-flex justify-content-center py-3">
                    <div class="align-self-center">
                        <#if order.state == 'PENDING' >
                            <form method="POST" action="/orders/resolve/${order.orderId}">
                                <button class="btn btn-outline-success">Resolve</button>
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="redirect" value="${redirectBackUrl}"/>
                            </form>
                        <#else >
                            <form method="POST" action="/orders/delete/${order.orderId}">
                                <button class="btn btn-danger">Delete</button>
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="redirect" value="${redirectBackUrl}"/>
                            </form>
                        </#if>
                        <#if order.state != 'CANCELLED' >
                            <form method="POST" action="/orders/cancel/${order.orderId}">
                                <button class="btn btn-outline-danger">Cancel</button>
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="redirect" value="${redirectBackUrl}"/>
                            </form>
                        </#if>
                    </div>
                </div>
            </div>
        </#list>
    </div>

    <#if orders.totalPageNumber != 0 >
        <div class="container">
            <ul class="pagination">
                <li class="page-item  <#if !orders.hasPreviousPage >disabled</#if>">
                    <a class="page-link"
                       href="?page=${orders.currentPageNumber - 1}&state=${currentState}" tabindex="-1">
                        Previous
                    </a>
                </li>
                <#list 1..orders.totalPageNumber as pageNumber>
                    <li class="page-item <#if orders.currentPageNumber == pageNumber>active</#if>">
                        <a class="page-link" href="?page=${pageNumber}&state=${currentState}">${pageNumber}</a>
                    </li>
                </#list>
                <li class="page-item <#if !orders.hasNextPage >disabled</#if>">
                    <a class="page-link"
                       href="?page=${orders.currentPageNumber + 1}&state=${currentState}" tabindex="-1">
                        Next
                    </a>
                </li>
            </ul>
        </div>

    </#if>

</body>
</html>

