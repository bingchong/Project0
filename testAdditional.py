import unittest
import os
import testLib

SUCCESS               =   1  # : a success
ERR_BAD_CREDENTIALS   =  -1  # : (for login only) cannot find the user/password pair in the database
ERR_USER_EXISTS       =  -2  # : (for add only) trying to add a user that already exists
ERR_BAD_USERNAME      =  -3  # : (for add, or login) invalid user name (only empty string is invalid for now)
ERR_BAD_PASSWORD      =  -4

class TestCases(testLib.RestTestCase):
    """Test adding users"""
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.SUCCESS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    #Successfully added a user
    def testSuccessfulAdd(self):
	respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'admin', 'password' : 'password'} )
        self.assertResponse(respData, 1, testLib.RestTestCase.SUCCESS)

    #Add user with empty username
    def testAddInvalidUser(self):
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : '', 'password' : 'password'} )
        self.assertResponse(respData, None, testLib.RestTestCase.ERR_BAD_USERNAME)

    #Add existing user
    def testAddExistingUser(self):
	self.makeRequest("/users/add", method="POST", data = { 'user' : 'admin', 'password' : 'password'} )
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'admin', 'password' : 'password'} )
        self.assertResponse(respData, None, testLib.RestTestCase.ERR_USER_EXISTS)

    #Add user with invalid username
    def testAddBadUserName(self):
	respData = self.makeRequest("/users/add", method="POST", data = { 'user' : '2'*130, 'password' : 'password'} )
        self.assertResponse(respData, None, testLib.RestTestCase.ERR_BAD_USERNAME)

    #Add user with invalid password
    def testAddBadPassword(self):
	respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'admin', 'password' : '2'*130} )
        self.assertResponse(respData, None, testLib.RestTestCase.ERR_BAD_PASSWORD)

    #Login with empty username
    def testInvalidUserLogin(self):
	respData = self.makeRequest("/users/login", method="POST", data = {'user' : '', 'password' : 'password'})
	self.assertResponse(respData, None, testLib.RestTestCase.ERR_BAD_CREDENTIALS)

    #Login with invalid password
    def testInvalidPassword(self):
	self.makeRequest("/users/add", method="POST", data = {'user' : 'admin', 'password' : 'password'})
	respData = self.makeRequest("/users/login", method="POST", data = {'user' : 'admin', 'password' : 'pass'})
	self.assertResponse(respData, None, testLib.RestTestCase.ERR_BAD_CREDENTIALS)

    #Login successfully
    def testSuccessfulLogin(self):
	self.makeRequest("/users/add", method="POST", data = {'user' : 'admin', 'password' : 'password'})
	respData = self.makeRequest("/users/login", method="POST", data = {'user' : 'admin', 'password' : 'password'})
	self.assertResponse(respData, 2, testLib.RestTestCase.SUCCESS)

    #Login with an invalid username
    def testLoginBadUserName(self):
	respData = self.makeRequest("/users/login", method="POST", data = { 'user' : '2'*130, 'password' : 'password'} )
        self.assertResponse(respData, None, testLib.RestTestCase.ERR_BAD_CREDENTIALS)

    #Login with an invalid password
    def testLoginBadPassword(self):
	respData = self.makeRequest("/users/login", method="POST", data = { 'user' : 'admin', 'password' : '2'*50} )
        self.assertResponse(respData, None, testLib.RestTestCase.ERR_BAD_CREDENTIALS)
