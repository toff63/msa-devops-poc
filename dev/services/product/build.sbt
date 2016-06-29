name := "product"

organization := "net.francesbagual.poc.devops"
version := "0.1"
scalaVersion := "2.11.7"
parallelExecution in ThisBuild := false
EclipseKeys.withSource := true

lazy val versions = new {
  val finatra = "2.1.6"
  val guice = "4.0"
  val logback = "1.0.13"
}

resolvers ++= Seq(
  Resolver.sonatypeRepo("releases"),
  "Twitter Maven" at "https://maven.twttr.com"
)

fork in run := true

assemblyMergeStrategy in assembly := {
  case "BUILD" => MergeStrategy.discard
  case other => MergeStrategy.defaultMergeStrategy(other)
}

libraryDependencies ++= Seq(
  "com.twitter.finatra" %% "finatra-http" % versions.finatra,
  "com.twitter.finatra" %% "finatra-httpclient" % versions.finatra,
  "ch.qos.logback" % "logback-classic" % versions.logback
)

