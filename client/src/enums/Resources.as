package enums
{
	import flash.text.Font;
    public class Resources
    {
        [Embed(source='../../ressources/fonts/LuckiestGuy.ttf', embedAsCFF='false', mimeType="application/x-font-truetype", unicodeRange = "U+0020-007E", fontName='Luckiest Guy')]
        public static var LuckiestGuy:Class;
        [Embed(source='../../ressources/fonts/HoboStd.otf', embedAsCFF='false', mimeType="application/x-font", unicodeRange = "U+0020-007E,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183", fontName='Hobo Std')]
        public static var HoboStd:Class;
        [Embed(source='../../ressources/fonts/collegiateHeavyOutline Medium.ttf', embedAsCFF='false', mimeType="application/x-font-truetype", unicodeRange = "U+0020,U+0041-005A,U+0061-007A", fontName='CollegiateHeavyOutline')]
        public static var CollegiateHeavyOutline:Class;
		
//		public static const LUCKIEST_FONT:Font = new LuckiestGuy();
//		public static const HOBO_STD_FONT:Font = new HoboStd();
//        public static const COLLEGIATE_HEAVY_OUTLINE_FONT:Font = new CollegiateHeavyOutline();
		
//		public static const fontList:Object = {"Hobo Std":HOBO_STD_FONT, "Luckiest Guy":LUCKIEST_FONT, "CollegiateHeavyOutline":COLLEGIATE_HEAVY_OUTLINE_FONT};
		
		public static const VERDANA_FONT_NAME:String = "Verdana";
		
		public static function initResources():void
		{
			Font.registerFont(LuckiestGuy);
			Font.registerFont(HoboStd);
			Font.registerFont(CollegiateHeavyOutline);
		}
    }
}