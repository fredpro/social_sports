package amfvo
{
    [RemoteClass(alias="amfvo.RequestVo")]
    public class RequestVo
    {
        /**
         * the data of the request to be sent to the service
         */
        public var data:Array;
        
        public function RequestVo(requestData:Object=null)
        {
            data = new Array();
            if (requestData != null)
            {
                for (var s:String in requestData)
                {
                    data[s] = requestData[s];
                }
            }
        }
    }
}