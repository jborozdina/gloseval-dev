import AssemblyKeys._

val scalaVersionStr   = "2.10.5"
val akkaVersion       = "2.3.9"
val sprayVersion      = "1.3.2"

organization          := "com.biosimilarity"

name                  := "GLoSEval-Dev"

version               := "0.0.1"

scalaVersion          := scalaVersionStr

ivyScala              := ivyScala.value map { _.copy(overrideScalaVersion = true) }

autoCompilerPlugins   := true

resolvers ++= Seq(
  "maven local repo" at "file:///"+Path.userHome.absolutePath+".m2/repository/",
  "maven remote repo" at "http://mvnrepository.com/artifact/",
  "spray repo" at "http://repo.spray.io/"
)

val commonDependencies: Seq[ModuleID] = Seq(
  "org.scala-lang"              % "scala-library"     % scalaVersionStr,
  "org.scala-lang"              % "scala-compiler"    % scalaVersionStr,
  "org.scala-lang"              %  "scala-actors"     % scalaVersionStr,
  "org.scala-lang"              % "scala-reflect"     % scalaVersionStr,
  "com.typesafe.akka"           %% "akka-actor"       % akkaVersion,
  "com.typesafe.akka"           %% "akka-slf4j"       % akkaVersion,
  "com.typesafe.akka"           %% "akka-testkit"     % akkaVersion  % "test",
  "io.spray"                    %% "spray-can"        % sprayVersion,
  "io.spray"                    %% "spray-routing"    % sprayVersion,
  "io.spray"                    %% "spray-json"       % sprayVersion,
  "io.spray"                    %% "spray-client"     % sprayVersion,
  "io.spray"                    %% "spray-testkit"    % sprayVersion % "test",
  "org.specs2"                  %% "specs2"           % "2.3.13"     % "test",
  "org.scalatest"               %  "scalatest_2.10"   % "2.2.1"      % "test",
  "com.rabbitmq"                %  "amqp-client"      % "2.6.1",
  "org.json4s"                  %% "json4s-native"    % "3.1.0",
  "org.json4s"                  %% "json4s-jackson"   % "3.1.0",
  "com.thoughtworks.xstream"    % "xstream"           % "1.4.2",
  "org.mongodb"                 % "casbah_2.10"       % "3.1.1",
  "biz.source_code"             % "base64coder"       % "2010-09-21",
  "org.scalaj"                  %% "scalaj-http"      % "2.3.0",
  "org.scalaz"                  %% "scalaz-core"      % "6.0.4",
  "org.apache.commons"          % "commons-email"     % "1.4",
  "com.googlecode.json-simple"  % "json-simple"       % "1.1.1",
  "log4j"                       % "log4j"             % "1.2.16",
  "org.slf4j"                   % "slf4j-api"         % "1.7.5",
  "org.codehaus.jettison"       % "jettison"          % "1.3.3",
  "xmldb"                       % "xmldb-api"         % "20021118",
  "javax.persistence"           % "persistence-api"   % "1.0.2",
  "org.basex"                   % "basex"             % "7.3.1",
  "commons-pool"                % "commons-pool"      % "1.6",
  "org.scalesxml"               % "scales-xml_2.10"   % "0.4.5",
  "net.spy"                     % "spymemcached"      % "2.9.0",
  "it.unibo.alice.tuprolog"     % "tuprolog"          % "2.1.1",
  "net.sf.squirrel-sql.thirdparty.non-maven" % "java-cup" % "11a",
  compilerPlugin("org.scala-lang.plugins" % "continuations" % "2.10.3")
)

lazy val root = project.in(file("."))
  .aggregate(agentservices, gloseval, specialk)
  .dependsOn(agentservices, gloseval, specialk)

lazy val gloseval =
  project.in( file("gloseval") ).dependsOn(agentservices, specialk)
    .settings(libraryDependencies := commonDependencies)
    .settings(scalacOptions  ++= Seq("-unchecked", "-deprecation", "-encoding", "utf8",  "-P:continuations:enable"))
    .settings(scalacOptions ++= Seq("-Xmax-classfile-name","200"))
    .settings(unmanagedJars in Compile ++= (baseDirectory.value/"../lib" ** "*.jar").classpath)


lazy val agentservices = project.in(file("agent-service-ati-ia/AgentServices-Store")).dependsOn(specialk)
  .settings(libraryDependencies ++= commonDependencies)
  .settings(scalacOptions  ++= Seq("-unchecked", "-deprecation", "-encoding", "utf8",  "-P:continuations:enable"))
  .settings(scalacOptions ++= Seq("-Xmax-classfile-name","200"))
  .settings(unmanagedJars in Compile ++= (baseDirectory.value/"../../lib" ** "*.jar").classpath)

lazy val specialk = project.in(file("specialk"))
  .settings(libraryDependencies ++= commonDependencies)
  .settings(scalacOptions  ++= Seq("-unchecked", "-deprecation", "-encoding", "utf8",  "-P:continuations:enable"))
  .settings(scalacOptions ++= Seq("-Xmax-classfile-name","200"))
  .settings(unmanagedJars in Compile ++= (baseDirectory.value/"../lib" ** "*.jar").classpath)


publishTo := Some(Resolver.file("file",  new File(Path.userHome.absolutePath+"/.m2/repository")))

mainClass in (Compile, run) := Some("com.biosimilarity.evaluator.spray.Boot")

sbtassembly.Plugin.assemblySettings

test in assembly := {}
