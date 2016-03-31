package com.analyzeme.rConfiguration;

/**
 * class saving configuration of RServe
 */
public class RServeConfiguration implements IRConfiguration{
    /**
     * field what show is processor active
     */
    private boolean flag;
    /**
     * field for saving host
     */
    private String host;
    /**
     * field for saving port
     */
    private String port;

    /**
     * default constructor
     */
    RServeConfiguration(){
        flag=true;
        host="";
        port="";
    }

    /**
     * constructor by param flag,host,port
     * @param flag for setting field flag
     * @param host for setting field host
     * @param port for setting field port
     */
    RServeConfiguration(boolean flag,String host,String port){
        this.flag=flag;
        this.host=host;
        this.port=port;
    }
    /**
     *set field flag
     * @param flag what will set as field flag
     */
    @Override
    public void setFlag(boolean flag) {
        this.flag=flag;
    }
    /**
     * get field flag
     * @return value of field flag
     */
    @Override
    public boolean getFlag() {
        return flag;
    }
    /**
     *set field flag
     * @param port what will set as field port
     */
    public void setPort(String port) {
        this.port=port;
    }
    /**
     * get field flag
     * @return value of field port
     */
    public String getPort() {
        return port;
    }
    /**
     *set field flag
     * @param host what will set as field host
     */
    public void setHost(String host) {
        this.host=host;
    }
    /**
     * get field flag
     * @return value of field host
     */
    public String getHost() {
        return host;
    }
}
