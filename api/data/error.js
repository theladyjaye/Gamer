// http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html - should we go this route?
module.exports = {
	"unauthorized_client":{"code":401, "message":"unauthorized_client"},
	"not_implemented"    :{"code":404, "message":"not_implemented"},
	"unknown_game"       :{"code":404, "message":"unknown_game"},
	"unknown_platform"   :{"code":400, "message":"unknown_platform"},
	"unknown_error"      :{"code":400, "message":"unknown_error"},
	"unknown_user"       :{"code":400, "message":"unknown_user"},
	"unknown_match"      :{"code":400, "message":"unknown_match"},
	"unknown_alias"     :{"code":400, "message" :"unknown_alias"},
	"schedule_time"      :{"code":400, "message":"invalid_schedule_time"},
	"create_match"       :{"code":400, "message":"unable_to_create_match"},
	"update_match"       :{"code":400, "message":"unable_to_update_match"}
}