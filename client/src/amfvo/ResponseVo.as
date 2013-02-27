package amfvo
{
    [RemoteClass(alias="amfvo.ResponseVo")]
    public class ResponseVo
    {
        public var status:int;
        
        public var statusMessage:String;
        
        /**
         * An object containing the right response data, when the request has been successful
         */
        public var result:Object;
        
//        public function ResponseVo(data:Object=null)
        public function ResponseVo(status:int = 0, statusMessage:String = "", result:Object = null)
        {
            //specific data casting
//            if (data != null)
//            {
//                status = data.status;
//                statusMessage = data.statusMessage;
//                result = data.result;
//            }
            this.status = status;
            this.statusMessage = statusMessage;
            this.result = result;
        }
        
        public function isSuccess():Boolean
        {
            return !this.status;
        }
    }
}