#Name: unidim seasonal component
#n = 1
#Input: VECTOR_DOUBLE
#Output: VECTORS_DOUBLE
data <- col_0 #or the URL of data from database
coefficientOfFrequency <- data[length(data)-2]
startPoint <- data[length(data)-1]
startPointFrequency <- data[length(data)]
data <- data[-c(length(data)-2, length(data)-1, length(data))]
dataTimeSeries <- ts(data, frequency = coefficientOfFrequency, start=c(startPoint, startPointFrequency))
MAseasonal <- as.vector(decompose(dataTimeSeries)$seasonal)
filter.stl<-stl(dataTimeSeries, "periodic")
STLseasonal <- as.vector(filter.stl$time.series[,1])
HWseasonal <- as.vector(HoltWinters(dataTimeSeries)$fitted[,'seasonal'])
result<-data.frame(MAseasonal, STLseasonal,HWseasonal)
names(result)<-c("Moving Averages", "LOESS method", "HWseasonal")
result