# typed: true

module Iterable
  ##
  #
  # Interact with /users API endpoints
  #
  # @example Creating users endpoint object
  #   # With default config
  #   templates = Iterable::Users.new
  #   templates.get
  #
  #   # With custom config
  #   conf = Iterable::Config.new(token: 'new-token')
  #   templates = Iterable::Users.new(config)
  class Users < ApiResource
    ##
    #
    # Update user data or adds a user if missing. Data is merged - missing
    # fields are not deleted
    #
    # @param email [String] (optional) User email used to identify user
    # @param attrs [Hash] Additional data to update or add
    #
    # @return [Iterable::Response] A response object
    sig do
      params(
        email: T.nilable(String),
        attrs: T::Hash[
          T.any(Symbol, String),
          T.any(T::Boolean, String, Integer, Float, NilClass)
        ]
      ).returns(Iterable::Response)
    end
    def update(email, attrs = {})
      attrs['email'] = email if email
      Iterable.request(conf, '/users/update').post(attrs)
    end

    ##
    #
    # Bulk update user data or adds it if does not exist. Data is merged and
    # missing fields are not deleted
    #
    # @param users [Array[Hash]] Array of hashes of user details
    #
    # @return [Iterable::Response] A response object
    #
    # @note User fields can be email [String], dataFields [Hash], or userId [String]
    sig do
      params(
        users: T::Array[
          T::Hash[
            T.any(Symbol, String),
            T.any(T::Boolean, String, Integer, Float, Hash)
          ]
        ]
      ).returns(Iterable::Response)
    end
    def bulk_update(users = [])
      Iterable.request(conf, '/users/bulkUpdate').post(users: users)
    end

    ##
    #
    # Update user subscriptions. Overwrites existing data if the field is
    # provided and not null
    #
    # @param email [String] (optional) User email used to identify user
    # @param attrs [Hash] Additional data to update
    #
    # @return [Iterable::Response] A response object
    sig do
      params(
        email: T.nilable(String),
        attrs: T::Hash[
          T.any(Symbol, String),
          T.any(T::Boolean, String, Integer, Float)
        ]
      ).returns(Iterable::Response)
    end
    def update_subscriptions(email, attrs = {})
      attrs['email'] = email if email
      Iterable.request(conf, '/users/updateSubscriptions').post(attrs)
    end

    ##
    #
    # Update user subscriptions in bulk. Overwrites existing data if the field is
    # provided and not null
    #
    # @param subscriptions [Array[Hash]] An array of subscription update attributes
    #
    # @return [Iterable::Response] A response object
    #
    # @note Refer to [Iterable::Users#update_subscriptions] for what subscription
    # information is needed such as email
    sig do
      params(
        subscriptions: T::Array[
          T::Hash[
            T.any(Symbol, String),
            T.any(T::Boolean, String, Integer, Float, Hash)
          ]
        ]
      ).returns(Iterable::Response)
    end
    def bulk_update_subscriptions(subscriptions = [])
      attrs = { updateSubscriptionsRequests: subscriptions }
      Iterable.request(conf, '/users/bulkUpdateSubscriptions').post(attrs)
    end

    ##
    #
    # Get a user by their email
    #
    # @param email [String] The email of the user to get
    #
    # @return [Iterable::Response] A response object
    sig { params(email: String).returns(Iterable::Response) }
    def for_email(email)
      Iterable.request(conf, "/users/#{email}").get
    end

    ##
    #
    # Update a user email
    #
    # @param email [String] The email of the user to get
    #
    # @return [Iterable::Response] A response object
    sig do
      params(
        email: String,
        new_email: String
      ).returns(Iterable::Response)
    end
    def update_email(email, new_email)
      attrs = { currentEmail: email, newEmail: new_email }
      Iterable.request(conf, '/users/updateEmail').post(attrs)
    end

    ##
    #
    # Delete a user by their email
    #
    # @param email [String] The email of the user to delete
    #
    # @return [Iterable::Response] A response object
    sig { params(email: String).returns(Iterable::Response) }
    def delete(email)
      Iterable.request(conf, "/users/#{email}").delete
    end

    ##
    #
    # Delete a user by their userId
    #
    # @param user_id [String] The userId of the user to delete
    #
    # @return [Iterable::Response] A response object
    sig { params(user_id: T.any(String, Integer)).returns(Iterable::Response) }
    def delete_by_id(user_id)
      Iterable.request(conf, "/users/byUserId/#{user_id}").delete
    end

    ##
    #
    # Get a user by their userId
    #
    # @param user_id [String] The user ID of the user to get
    #
    # @return [Iterable::Response] A response object
    sig { params(user_id: T.any(String, Integer)).returns(Iterable::Response) }
    def for_id(user_id)
      Iterable.request(conf, "/users/byUserId/#{user_id}").get
    end

    ##
    #
    # Get the user fields with mappings from field to type
    #
    # @return [Iterable::Response] A response object
    sig { returns(Iterable::Response) }
    def fields
      Iterable.request(conf, '/users/getFields').get
    end

    ##
    #
    # Register a browser token for a user
    #
    # @param email [String] An email of a user
    # @param token [String] The browser token to register
    # @param attrs [Hash] Additional attrs like userId to pass along
    #
    # @return [Iterable::Response] A response object
    #
    # @note An email or userId is required
    sig do
      params(
        email: String,
        token: String,
        attrs: T::Hash[
          T.any(Symbol, String),
          T.any(T::Boolean, String, Integer, Float, Hash)
        ]
      ).returns(Iterable::Response)
    end
    def register_browser_token(email, token, attrs = {})
      attrs[:email] = email
      attrs[:browserToken] = token
      Iterable.request(conf, '/users/registerBrowserToken').post(attrs)
    end

    ##
    #
    # Disable a device
    #
    # @param token [String] A device token to disable
    # @param email [String] Optional user email device belongs to to disable
    # @param user_id [String] Optional user_id device belongs to to disable
    #
    # @return [Iterable::Response] A response object
    #
    # @note An email or userId is required
    sig do
      params(
        token: String,
        email: T.nilable(String),
        user_id: T.nilable(T.any(String, Integer))
      ).returns(Iterable::Response)
    end
    def disable_device(token, email = nil, user_id = nil)
      attrs = { token: token }
      attrs[:email] = email if email
      attrs[:userId] = user_id if user_id
      Iterable.request(conf, '/users/disableDevice').post(attrs)
    end

    ##
    #
    # Get sent messages for a user
    #
    # @param email [String] An email for a user to retreive messages for
    # @param start_time [Time] An optional start time for range of messages
    # @param end_time [Time] An optional end time for range of messages
    # @param params [Hash] Additional params to use to filter messages further
    #
    # @return [Iterable::Response] A response object
    sig do
      params(
        email: String,
        start_time: T.nilable(T.any(Time, Date)),
        end_time: T.nilable(T.any(Time, Date)),
        params: T::Hash[
          T.any(Symbol, String),
          T.any(T::Boolean, String, Integer, Float, Hash)
        ]
      ).returns(Iterable::Response)
    end
    def sent_messages(email, start_time = nil, end_time = nil, params = {})
      params[:email] = email
      params[:startTime] = start_time.to_s if start_time
      params[:endTime] = end_time.to_s if end_time
      Iterable.request(conf, '/users/getSentMessages', params).get
    end

    ##
    #
    # Delete the specified user's data from the Iterable project and
    # prevent future data collection about them.
    #
    # @param email [String] User email to forget
    #
    # @return [Iterable::Response] A response object
    sig { params(email: String).returns(Iterable::Response) }
    def forget(email)
      attrs = { email: email }
      Iterable.request(conf, '/users/forget').post(attrs)
    end
  end
end
