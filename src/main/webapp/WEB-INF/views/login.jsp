<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>LOGIN</title>

    <link href="${contextPath}/resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="${contextPath}/resources/css/common.css" rel="stylesheet">
    <link href="${contextPath}/resources/css/profile.css" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="https://bootswatch.com/cosmo/bootstrap.min.css">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>

<body background="${contextPath}/resources/Images/login-background.png">

    <div class="mainbody container-fluid">
        <div class="row">
            <div class="navbar-wrapper">
                <div class="container-fluid">
                    <div class="navbar navbar-custom navbar-static-top" role="navigation">
                        <div class="container-fluid">
                            <div class="navbar-header">
                                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                                    <span class="sr-only">Toggle navigation</span>
                                    <span class="icon-bar"></span>
                                    <span class="icon-bar"></span>
                                    <span class="icon-bar"></span>
                                </button>
                                <a class="navbar-brand" href="${contextPath}/index">HKH Infotech</a>
                                <i class="brand_network"><small><small>VProfile</small></small></i>
                            </div>
                            <div class="navbar-collapse collapse">
                                <ul class="nav navbar-nav">
                                    <li><a href="#">TECHNOLOGIES</a></li>
                                    <li><a href="#">ABOUT</a></li>
                                    <li><a href="#">BLOG</a></li>
                                </ul>
                                <div class="navbar-collapse navbar-right collapse">
                                    <ul class="nav navbar-nav">
                                        <li><a href="${contextPath}/login">LOGIN</a></li>
                                        <li><a href="${contextPath}/registration">SIGN UP</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <form method="POST" action="${contextPath}/login" class="form-signin">
            <h2 class="form-heading" align="center">WELCOME!</h2>
            <p style="text-align:center; color: green; font-weight: bold;">Jenkins CI/CD test-1</p>
            <p style="text-align:center; color: green; font-weight: bold;">Jenkins CI/CD test-2 recreate</p>
            <p style="text-align:center; color: green; font-weight: bold;">Jenkins CI/CD test-3 rolling-update</p>
            <p style="text-align:center; color: green; font-weight: bold;">Jenkins CI/CD test-4 argocd-deployment</p>
            <p style="text-align:center; color: green; font-weight: bold;">Jenkins CI/CD test-5 github-actions ci/cd</p>
            <img class="logo" src="${contextPath}/resources/Images/hkh-infotech-logo.png" />

            <div class="form-group ${error != null ? 'has-error' : ''}">
                <span>${message}</span>
                <input name="username" type="text" class="form-control" placeholder="Username" />
                <input name="password" type="password" class="form-control" placeholder="Password" />
                <span>${error}</span>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <button class="btn btn-custom-LOGIN btn-lg btn-block" type="submit">LOGIN</button>
                <h4 class="text-center">
                    <a href="${contextPath}/registration">SIGN UP</a>
                </h4>
            </div>
        </form>
    </div>

    <!-- /container -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script src="${contextPath}/resources/js/bootstrap.min.js"></script>

</body>
</html>
