default:
	rm -f *.class
	javac -cp "core.jar" PID_Visualizer.java
	java -cp "core.jar:." PID_Visualizer

clean:
	rm -f *.class

run:
	java -cp "core.jar:." PID_Visualizer
