package enums
{
	import flash.text.Font;
    public class Resources
    {
        [Embed(source='../../ressources/fonts/LuckiestGuy.ttf', embedAsCFF='false', fontName='Luckiest Guy')]
        public static var LuckiestGuy:Class;
        [Embed(source='../../ressources/fonts/HoboStd.ttf', embedAsCFF='false', fontName='Hobo Std')]
        public static var HoboStd:Class;
        [Embed(source='../../ressources/fonts/collegiateHeavyOutline Medium.ttf', embedAsCFF='false', fontName='CollegiateHeavyOutline')]
        public static var CollegiateHeavyOutline:Class;
		
		public static const LUCKIEST_FONT:Font = new LuckiestGuy();
		public static const HOBO_STD_FONT:Font = new HoboStd();
        public static const COLLEGIATE_HEAVY_OUTLINE_FONT:Font = new CollegiateHeavyOutline();
        
        public static const VERDANA_FONT_NAME:String = "Verdana";
    }
}