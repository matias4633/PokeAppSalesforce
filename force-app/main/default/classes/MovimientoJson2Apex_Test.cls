//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class MovimientoJson2Apex_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'  \"accuracy\": 100,'+
		'  \"effect_chance\": null,'+
		'  \"effect_entries\": ['+
		'    {'+
		'      \"effect\": \"Inflicts regular damage.\",'+
		'      \"language\": {'+
		'        \"name\": \"en\",'+
		'        \"url\": \"https://pokeapi.co/api/v2/language/9/\"'+
		'      },'+
		'      \"short_effect\": \"Inflicts regular damage with no additional effect.\"'+
		'    }'+
		'  ],'+
		'  \"id\": 1,'+
		'  \"name\": \"pound\",'+
		'  \"power\": 40,'+
		'  \"pp\": 35,'+
		'  \"priority\": 0,'+
		'  \"target\": {'+
		'    \"name\": \"selected-pokemon\",'+
		'    \"url\": \"https://pokeapi.co/api/v2/move-target/10/\"'+
		'  },'+
		'  \"type\": {'+
		'    \"name\": \"normal\",'+
		'    \"url\": \"https://pokeapi.co/api/v2/type/1/\"'+
		'  }'+
		'}';
		MovimientoJson2Apex r = MovimientoJson2Apex.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		MovimientoJson2Apex.Language objLanguage = new MovimientoJson2Apex.Language(System.JSON.createParser(json));
		System.assert(objLanguage != null);
		System.assert(objLanguage.name == null);
		System.assert(objLanguage.url == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		MovimientoJson2Apex.Effect_entries objEffect_entries = new MovimientoJson2Apex.Effect_entries(System.JSON.createParser(json));
		System.assert(objEffect_entries != null);
		System.assert(objEffect_entries.effect == null);
		System.assert(objEffect_entries.language == null);
		System.assert(objEffect_entries.short_effect == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		MovimientoJson2Apex objMovimientoJson2Apex = new MovimientoJson2Apex(System.JSON.createParser(json));
		System.assert(objMovimientoJson2Apex != null);
		System.assert(objMovimientoJson2Apex.accuracy == null);
		System.assert(objMovimientoJson2Apex.effect_chance == null);
		System.assert(objMovimientoJson2Apex.effect_entries == null);
		System.assert(objMovimientoJson2Apex.id == null);
		System.assert(objMovimientoJson2Apex.name == null);
		System.assert(objMovimientoJson2Apex.power == null);
		System.assert(objMovimientoJson2Apex.pp == null);
		System.assert(objMovimientoJson2Apex.priority == null);
		System.assert(objMovimientoJson2Apex.target == null);
		System.assert(objMovimientoJson2Apex.type == null);
	}
}