��� ������������� .bat ������ ��������� ������, ���������� � Tomcat, ����������:
 1. ���������� maven:
	- ������� � ����������� ����� apache-maven (������������� � Apache Maven 3.3.3)
	- ��������� �������� environment variable JAVA_HOME - ��� ������ ������������ � ��������� �� ����� ${you_jdk_directory}
	- ��������� �������� environment variable PATH - � ��� ������ �����������, ����� �������, �������� �� ����� ${you_jdk_directory}\bin (������ ����������, ����� ������ ����: ��-�� ��������, ��������� �� ���, ��������, Oracle, ����� ��������� ������) 
	- �������� �  environment variable PATH �������� �� ����� ${your_maven_directory}\bin
 2. ���������� Tomcat:
	- ������� � ����������� ����� apache-tomcat (������������� � Apache Tomcat 7.0.65)
	- ���������� �������� environment variable CATALINA_HOME, �������� �� ������������� �����
 3. ��������� �� ��������� ������ tomcat_first.bat
 
 ��������� ������ �������� �� ������ http://localhost:8080/analyzeme/ �� ��������������� ��������